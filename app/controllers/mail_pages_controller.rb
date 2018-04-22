class MailPagesController < ApplicationController
  def inbox
    if !logged_in?
      redirect_to login_url
    else
      @all_received = SenderReceiver.where(receiver_user_id: current_user.id)
    end
  end

  def sent
    if !logged_in?
      redirect_to login_url
    else
      @all_sent = SenderReceiver.where(sender_user_id: current_user.id)
    end
  end

  def draft
    if !logged_in?
      redirect_to login_url
    end
  end

  def trash
    if !logged_in?
      redirect_to login_url
    end
  end

  def compose
    if !logged_in?
      redirect_to login_url
    else
      @to_value = ""
      @sub_value = ""
      @body_value = ""
      @email = current_user.emails.build if logged_in?
    end
  end
end
