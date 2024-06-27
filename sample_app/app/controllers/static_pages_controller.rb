class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @pagy_feed, @feed_items = pagy(current_user.feed)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
