=begin
◆概要
スキルメッセージに表示する情報を拡張します。

◆機能
・特定の文字をスキルメッセージに入れておくとその文字に対応した情報をスキルの
使用メッセージに表示します。
・(以下、全てカギ括弧不要)
｢\B｣……使用者の名前を表示しません。
｢\T｣……対象の名前を表示します。
｢\Ts｣……対象の名前を表示します。対象が複数の場合自動的に｢たち｣がつきます。
　　　　その場合対象の先頭の名前を表示します。
｢\U｣……使用者の名前を表示します。

◆仕様
・ターゲットなしで｢\T｣を入れた場合は\Tが消えませんので注意。

◆使用上の注意
・●……再定義　○……新規定義

=end

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : スキル
  #--------------------------------------------------------------------------
  def execute_action_skill
    skill = @active_battler.action.skill
    targets = @active_battler.action.make_targets
    text = skill.message1.include?("\BN") ? "" : @active_battler.name
    text += gsub_skill_message(skill.message1, targets[0], targets.size > 1)
    @message_window.add_instant_text(text)
    unless skill.message2.empty?
      wait(0)
      text = gsub_skill_message(skill.message2, targets[0], targets.size > 1)
      @message_window.add_instant_text(text)
    end
    display_animation(targets, skill.animation_id)
    @active_battler.mp -= @active_battler.calc_mp_cost(skill)
    $game_temp.common_event_id = skill.common_event_id
    for target in targets
      target.skill_effect(@active_battler, skill)
      display_action_effects(target, skill)
    end
  end
  #--------------------------------------------------------------------------
  # ○ スキルメッセージの改竄()
  #--------------------------------------------------------------------------
  def gsub_skill_message(text, target, multi)
    text_c = text.clone
    text_c.gsub!("\\BN"){|t|}
    text_c.gsub!("\\Ts"){|t|t = target.name + (multi ? "たち" : "")} if target
    text_c.gsub!("\\T"){|t|t = target.name} if target
    text_c.gsub!("\\U"){|t|t = @active_battler.name} if @active_battler
    text_c
  end
end
