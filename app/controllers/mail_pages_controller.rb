class MailPagesController < ApplicationController
  def inbox
    if !logged_in?
      redirect_to login_url
    else
      @all_received = SenderReceiver.where("receiver_user_id = ? AND is_deleted_by_receiver = ?", current_user.id, false)
    end
  end

  def sent
    if !logged_in?
      redirect_to login_url
    else
      @all_sent = SenderReceiver.where("sender_user_id = ? AND is_deleted_by_sender = ?", current_user.id, false)
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
    else
      @all_deleted = SenderReceiver.where("(receiver_user_id = ? AND is_deleted_by_receiver = ?) OR (sender_user_id = ? AND is_deleted_by_sender = ?)", current_user.id, true, current_user.id, true)
      email_ids = Array.new
      for del in @all_deleted
        email_ids.push(del.email.id)
      end

      unique_email_ids = Set.new
      for id in email_ids do
        logger.debug "QQQQQ"
        unique_email_ids.add(id)
      end

      id_array = Array.new
      for id in unique_email_ids do
        id_array.push(id)
      end

      @all_deleted_email = Email.where(id: id_array)

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
