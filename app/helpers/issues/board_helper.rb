module Issues::BoardHelper
  def board_session
    session[:board_issues] ||= []
  end
end
