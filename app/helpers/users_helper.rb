module UsersHelper
  
  # users => show.html.erb の勤怠基本情報のフォーマット変更。  
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end

end
