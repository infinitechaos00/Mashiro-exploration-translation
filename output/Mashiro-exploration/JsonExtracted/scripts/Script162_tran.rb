#==============================================================================
# ■ Main
#------------------------------------------------------------------------------
# 　各クラスの定義が終わった後、ここから実際の処理が始まります。
#==============================================================================

unless Font.exist?("Segoe UI")
  print "Segoe UI"
  exit
end



begin
  Font.default_size = 18
  Font.default_name = "Segoe UI"
  Graphics.freeze
  $scene = Scene_Title.new
  $scene.main while $scene != nil
  Graphics.transition(30)
rescue Errno::ENOENT
  filename = $!.message.sub("No such file or directory - ", "")
  print("ファイル #{filename} が見つかりません。")
end
