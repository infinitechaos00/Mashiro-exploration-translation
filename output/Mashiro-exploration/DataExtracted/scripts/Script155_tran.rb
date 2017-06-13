=begin
---
■スキルのヒット数増加 by くー
http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1173398631
から

【仕様】
スキルのヒット数を自由に変更できます。
単体およびランダムターゲットにも対応。
ただし対象は敵のみです。

また、ヒット数を一定範囲内の乱数にすることも出来ます。
---
【使い方】
スキルのメモ欄に、以下を入力してください。(n, mは半角数字)

ヒット回数<n,m>

上記は、n以上m以下の乱数回ヒットすることを示しています。
ヒット数を固定にする場合は、nとmを同じ数字にしてください。

ターゲットは、
敵単体（連続）
敵○体 ランダム
を選んでください。

---
=end

module FW
module Skill
# ヒット回数
COUNT = /^ヒット回数<(\S+),(\S+)>/
end
end

module RPG
class UsableItem
def counter_startup
@count = []
@note.split(/[\n]+/).each { |str|
case str
when FW::Skill::COUNT
@count.push($1.to_i)
@count.push($2.to_i)
end
}
end
def count
counter_startup if @count == nil
return @count
end
end
end

#==============================================================================
# ■ Game_BattleAction
#------------------------------------------------------------------------------
# 戦闘行動を扱うクラスです。このクラスは Game_Battler クラスの内部で使用され
# ます。
#==============================================================================

class Game_BattleAction
#--------------------------------------------------------------------------
# ● 攻撃回数の計算
#--------------------------------------------------------------------------
def calc_count(count)
return -1 if count.size == 0
return [count[0], rand(count[1] + 1)].max
end
#--------------------------------------------------------------------------
# ● スキルまたはアイテムのターゲット作成 # 再定義
# obj : スキルまたはアイテム
#--------------------------------------------------------------------------
def make_obj_targets(obj)
targets = []
count = calc_count(obj.count)
if obj.for_opponent?
if obj.for_random?
if obj.for_one? # 敵単体 ランダム
number_of_targets = 1
elsif obj.for_two? # 敵二体 ランダム
number_of_targets = 2
else # 敵三体 ランダム
number_of_targets = 3
end
number_of_targets = count if count > 0
number_of_targets.times do
targets.push(opponents_unit.random_target)
end
elsif obj.dual? # 敵単体 連続
count = 2 if count < 0
targets.push(opponents_unit.smooth_target(@target_index))
target2 = targets
count -= 1
count.times do
targets += target2
end
elsif obj.for_one? # 敵単体
targets.push(opponents_unit.smooth_target(@target_index))
else # 敵全体
targets += opponents_unit.existing_members
end
elsif obj.for_user? # 使用者
targets.push(battler)
elsif obj.for_dead_friend?
if obj.for_one? # 味方単体 (戦闘不能)
targets.push(friends_unit.smooth_dead_target(@target_index))
else # 味方全体 (戦闘不能)
targets += friends_unit.dead_members
end
elsif obj.for_friend?
if obj.for_one? # 味方単体
targets.push(friends_unit.smooth_target(@target_index))
else # 味方全体
targets += friends_unit.existing_members
end
end
return targets.compact
end
end