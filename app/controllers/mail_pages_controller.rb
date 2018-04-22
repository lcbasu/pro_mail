class MailPagesController < ApplicationController
  def inbox
    if !logged_in?
      redirect_to login_url
    end
  end

  def sent
    if !logged_in?
      redirect_to login_url
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
    end
  end
end
