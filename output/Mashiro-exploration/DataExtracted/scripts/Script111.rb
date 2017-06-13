#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 素手詳細設定 - KGC_DetailedBareHands ◆ VX ◆
#_/    ◇ Last update : 2008/09/13 ◇
#_/----------------------------------------------------------------------------
#_/  素手状態の設定を詳細化します。
#_/============================================================================
#_/ 【基本機能】≪攻撃属性設定≫ より上に導入してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module DetailedBareHands
  # ◆ 素手の攻撃属性
  #  データベースの属性 ID を , 区切りで指定。
  BAREHANDS_ELEMENTS = [1]

  # ◆ アクターごとの素手の攻撃属性
  #  各アクターの素手属性を
  #   PERSONAL_BAREHANDS_ELEMENTS[アクター ID] = [属性, ...]
  #  という書式で指定。
  #  指定しなかったアクターは BAREHANDS_ELEMENTS を使用。
  PERSONAL_BAREHANDS_ELEMENTS = []
  # ～ ここから下に追加 ～
  #  <例> アクター 1 の攻撃属性を 1, 2, 3 にする
  # PERSONAL_BAREHANDS_ELEMENTS[1] = [1, 2, 3]
  PERSONAL_BAREHANDS_ELEMENTS[18] = [1, 20]
  # ◆ 素手の攻撃アニメーション ID
  BAREHANDS_ANIMATION = 1

  # ◆ アクターごとの素手の攻撃属性
  #  各アクターの素手属性を
  #   PERSONAL_BAREHANDS_ANIMATION[アクター ID] = アニメ ID
  #  という書式で指定。
  #  指定しなかったアクターは BAREHANDS_ANIMATION を使用。
  PERSONAL_BAREHANDS_ANIMATION = []
  # ～ ここから下に追加 ～
  #  <例>
  # PERSONAL_BAREHANDS_ANIMATION[1] = 2
  PERSONAL_BAREHANDS_ANIMATION[18] = 131
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["DetailedBareHands"] = true

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 通常攻撃の属性取得
  #--------------------------------------------------------------------------
  alias element_set_KGC_DetailedBareHands element_set
  def element_set
    if weapons.compact == []
      result = KGC::DetailedBareHands::PERSONAL_BAREHANDS_ELEMENTS[self.id]
      result = KGC::DetailedBareHands::BAREHANDS_ELEMENTS if result == nil
      return result
    end

    return element_set_KGC_DetailedBareHands
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃 アニメーション ID の取得
  #--------------------------------------------------------------------------
  alias atk_animation_id_KGC_DetailedBareHands atk_animation_id
  def atk_animation_id
    result = KGC::DetailedBareHands::PERSONAL_BAREHANDS_ANIMATION[self.id]
    result = KGC::DetailedBareHands::BAREHANDS_ANIMATION if result == nil
    if two_swords_style
      return result if weapons[0] == nil && weapons[1] == nil
    else
      return result if weapons[0] == nil
    end

    return atk_animation_id_KGC_DetailedBareHands
  end
end
