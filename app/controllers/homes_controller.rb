class HomesController < ApplicationController
  before_action :hide_search, only: [:top, :about]

  def top
  end
  
  def about
  end

  private

  def hide_search
    @show_search = false
  end
end
