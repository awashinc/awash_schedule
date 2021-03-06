class CalendarsController < ApplicationController

  before_action :authenticate_admin_user!
  before_action :set_calendar_auth, only: [:create, :update, :destroy, :specific_list, :specific_edit, :specific_update]

  def index
    @calendars = Calendar.page(params[:page]).per(params[:per])
    @soon_end_calendars = Calendar.where("calendars.is_extend = 0 and calendars.end_date <= ?",Date.current + 1.week)
  end

  def show
    @calendar = Calendar.find(params[:id])
  end

  def new
    @calendar = Calendar.new
    @calendar = Calendar.find(params[:extend_id]).dup_calendar if params[:extend_id].present?
  end

  def create

=begin
    e.start_time =  Time.parse("2017-03-29 14:00")
    e.end_time = Time.parse("2017-03-29 15:00")
    e.recurrence = {freq: "weekly", interval: 2,  until: Time.parse("20170717T130000Z") }
    e.title= "Sample Calendar"
    e.location = "용산구 한남동 123-4 "
    e.description = "정고객 010-2233-1234 벤츠"
=end

    @calendar = Calendar.new(calendar_param)


=begin
   begin

    @response = @cal.create_event do  |e|
      start_time = Time.parse("#{params[:do_start]} #{params[:time_sel]}")
      e.start_time = start_time
      e.end_time = start_time + 2.hours
      until_time = Time.parse("#{params[:do_until]} #{params[:time_sel]}")  + 2.hours
      case params[:per_wash]
      when "1"
        e.recurrence = {freq: "weekly", interval: 1,  until: until_time  }
      when "2"
        e.recurrence = {freq: "weekly", interval: 2,  until: until_time }
      end
      e.title= params[:name]
      e.location = params[:address]
      e.description = "#{params[:car_number]}, #{parmas[:wash_type]}, #{params[:memo]}"
    end

    redirect_to calendars_path(cal_id: @response.id)

   rescue
    render :action => 'new'
   end
=end

     @calendar.start_date = @calendar.start_date.beginning_of_week + @calendar.day_sel.to_i.days

     if @calendar.save

        Calendar.where(id: params[:extend_id]).first.update_extend if params[:extend_id].present?

        @cal = Google::Calendar.new(client_id: ENV['GOOGLE_API_CLIENT_ID'],
           :client_secret => ENV['GOOGLE_API_SECRET'],
           :calendar      => ENV['GOOGLE_CALENDAR_ID'],
           :redirect_url  => "#{OmniAuth.config.full_host}/admin_users/auth/google_oauth2/callback"
          )

        @cal.login_with_refresh_token(current_admin_user.refresh_token)

        @response = @cal.create_event do  |e|
          #start_time = Time.zone.parse("#{@calendar.start_date} #{@calendar.time_sel}+0900")
          #e.start_time = start_time
          # e.end_time = start_time + 2.hours
          #until_time = Time.zone.parse("#{@calendar.end_date} #{@calendar.time_sel}+0900")  + 2.hours

          start_date = Time.zone.parse("#{@calendar.start_date}")
          e.all_day = start_date
          until_date = Time.zone.parse("#{@calendar.end_date}")
          case @calendar.per_wash
          when 1
            e.recurrence = {freq: "weekly", interval: 1,  until: until_date }
          when 2
            e.recurrence = {freq: "weekly", interval: 2,  until: until_date }
          end
          e.title= @calendar.name
          e.location = @calendar.address
          e.description = "전화번호: #{@calendar.phone}\n#{@calendar.car_number}, #{@calendar.memo}"
        end

        @calendar.update_attributes(calendar_response: @response.raw, calendar_id: @response.raw["id"])

       redirect_to calendars_path
     else
       render :new
     end



  end

  def edit
    @calendar = Calendar.find(params[:id])
  end

  def update

    # Time.now.utc.strftime("%Y%m%dT%H%M%S")
    # @cal.find_event_by_id("884isjn66ger2qnvrjlmlk2o78_20170426T050000Z" )

    @calendar = Calendar.find(params[:id])

    if @calendar.update_attributes(calendar_param)


      @calendar.start_date = @calendar.start_date.beginning_of_week + @calendar.day_sel.to_i.days
      @response = @cal.find_or_create_event_by_id(@calendar.calendar_id) do  |e| 
        #start_time = Time.zone.parse("#{@calendar.start_date} #{@calendar.time_sel}+0900")
        #e.start_time = start_time
        #e.end_time = start_time + 2.hours
        #until_time = Time.zone.parse("#{@calendar.end_date} #{@calendar.time_sel}+0900")  + 2.hours

        start_date = Time.zone.parse("#{@calendar.start_date}")
        e.all_day = start_date
        until_date = Time.zone.parse("#{@calendar.end_date}")
        case @calendar.per_wash
        when 1
          e.recurrence = {freq: "weekly", interval: 1,  until: until_date  }
        when 2
          e.recurrence = {freq: "weekly", interval: 2,  until: until_date  }
        end
        e.title= @calendar.name
        e.location = @calendar.address
        e.description = "전화번호: #{@calendar.phone}\n#{@calendar.car_number}, #{@calendar.memo}"
      end

      @calendar.update_attributes(calendar_response: @response.raw )



      redirect_to calendars_path, :notice  => "Successfully updated calendar."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy
    redirect_to calendars_url, :notice => "Successfully destroyed calendar."
  end

  def specific_list

    @calendar = Calendar.find(params[:id])
    cal_uid = eval(@calendar.calendar_response)["iCalUID"]
    @event_list =  @cal.find_events("&singleEvents=true&iCalUID=#{cal_uid}&orderBy=startTime")
  end

  def specific_edit
    @calendar = Calendar.find(params[:id])
    @event = @cal.find_event_by_id(params[:calendar_id]).first
    @info = @event.raw
    @time_custom = @info["start"]["dateTime"].present? &&  !["10:00","13:00","16:00"].include?(DateTime.parse(@info["start"]["dateTime"]).strftime("%H:%M"))

  end

  def specific_update
    @calendar = Calendar.find(params[:id])

    @response = @cal.find_or_create_event_by_id(params[:event_id]) do  |e|

      if params[:is_custom] == "1"
        start_time = Time.zone.parse("#{params[:start_date]} #{params[:time_sel_custom]}+0900")
        e.start_time = start_time
        e.end_time = start_time + 2.hours
      elsif params[:time_sel].present?
        start_time = Time.zone.parse("#{params[:start_date]} #{params[:time_sel]}+0900")
        e.start_time = start_time
        e.end_time = start_time + 2.hours
      else
        start_date = Time.zone.parse("#{params[:start_date]}")
        e.all_day = start_date
      end

      e.title = params[:name]
      e.location = params[:address]
      e.description = params[:description]
    end

   redirect_to specific_list_calendar_path(@calendar)



  end



  private
  def set_calendar_auth

    @cal = Google::Calendar.new(client_id: ENV['GOOGLE_API_CLIENT_ID'],
       :client_secret => ENV['GOOGLE_API_SECRET'],
       :calendar      => ENV['GOOGLE_CALENDAR_ID'],
       :redirect_url  => "#{OmniAuth.config.full_host}/admin_users/auth/google_oauth2/callback"
      )


    @cal.login_with_refresh_token(current_admin_user.refresh_token)
    current_admin_user.update_attributes(refresh_token: @cal.refresh_token) if @cal.refresh_token != current_admin_user.refresh_token

  end

  def calendar_param
    params.require(:calendar).permit(:name, :per_wash, :wash_type, :start_date, :end_date, :day_sel, :time_sel, :phone, :address, :car_number, :memo)
  end
end
