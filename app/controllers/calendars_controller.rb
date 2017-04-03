class CalendarsController < ApplicationController

  before_action :authenticate_admin_user!
  before_action :set_calendar_auth

  def index
#    @calendars = Calendar.all
  end

  def show
    @calendar = Calendar.find(params[:id])
  end

  def new
#    @calendar = Calendar.new
  end

  def create

=begin
    e.start_time =  Time.parse("2017-03-29 14:00")
    e.end_time = Time.parse("2017-03-29 15:00")
    e.recurrence = {freq: "weekly", interval: 2,  until: Time.parse("20170717T130000Z") }
    e.title= "Sample Calendar"
    e.location = "용산구 한남동 657-8 "
    e.description = "정요숙 010-5261-6136 벤츠"
=end


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
      e.description = "#{params[:car_number]}, #{params[:memo]}"
    end

    binding.pry
    redirect_to calendars_path(cal_id: @response.id)

   rescue
    render :action => 'new'
   end

  end

  def edit
    @calendar = Calendar.find(params[:id])
  end

  def update
    @calendar = Calendar.find(params[:id])
    if @calendar.update_attributes(params[:calendar])
      redirect_to @calendar, :notice  => "Successfully updated calendar."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy
    redirect_to calendars_url, :notice => "Successfully destroyed calendar."
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
end
