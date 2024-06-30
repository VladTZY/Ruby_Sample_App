class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @microposts_count = current_user.feed.count
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
