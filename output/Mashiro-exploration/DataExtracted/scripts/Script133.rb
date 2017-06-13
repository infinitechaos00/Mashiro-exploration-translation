# ▽▽▽ XRXSv24. アイテム対象制限／スキル使用条件　▽▽▽
#
# publish 2010/ 3/18
# update　   -  5/ 4
#
#~ 下記の文字列をメモに記述する事で、特殊な効果を設定できます。
#~ 　アイテムのメモ　に記述した場合、使用される対象に制限を
#~ 　スキルのメモ　　に記述した場合、使用できる使用者に制限をします。
#~ 制御文字
#~ 　\needclass[1,2,3]
#~ 　　　[]内に記されたIDを持つクラスのアクター　を条件とします。
#~ 　　　[]内の数値をコンマで区切って記述します。

#~ \needskill[n]
#~ 　　　n 番のスキルを習得していること　を条件とします。

#~ 　\needlv[n]
#~ ／\limitlevel[n]
#~ 　　　レベル n 以上／以下　を条件とします。

#~ 　\needhp[n]　\needmp[n]　\needmhp[n]　\needmmp[n]
#~ ／\limithp[n]　\limitmp[n]　\limimhp[n]　\limitmmp[n]
#~ 　　　それぞれ 現在HP・現在MP・最大HP・最大MPが n 以上／以下を条件とします。

#~ 　\needatk[n]　\needdef[n]　\needspi[n]　\needagi[n]
#~ ／\limitatk[n]　\limitdef[n]　\limitpi[n]　\limitagi[n]
#~ 　　　それぞれ 攻撃力・防御力・精神力・敏捷性が n 以上／以下を条件とします。
#==============================================================================
# カスタマイズポイント
#==============================================================================
module XRXSV24
  def skill_can_use?(skill)
    return false if skill and not note_check(skill.note)
    return super
  end
  def item_effective?(user, item)
    return false if not note_check(item.note)
    return super
  end
  def note_check(note)
    result = true
    note = note.dup
    note.gsub!(/\\needclass\[(.+?)\]/) do
      numbers = $1.split(/,/)
      if numbers.size >= 1
        result = false
        for n in numbers
          result |= n.to_i == self.class_id
        end
      end
    end
    note.gsub!(/\\needskill\[([0-9]+?)\]/){ result &= self.skill_learn?($data_skills[$1.to_i]) }
    note.gsub!(/\\needlv\[([0-9]+?)\]/){ result &= $1.to_i <= self.level }
    note.gsub!(/\\needhp\[([0-9]+?)\]/){ result &= $1.to_i <= self.hp }
    note.gsub!(/\\needmp\[([0-9]+?)\]/){ result &= $1.to_i <= self.mp }
    note.gsub!(/\\needmhp\[([0-9]+?)\]/){ result &= $1.to_i <= self.maxhp }
    note.gsub!(/\\needmmp\[([0-9]+?)\]/){ result &= $1.to_i <= self.maxmp }
    note.gsub!(/\\needatk\[([0-9]+?)\]/){ result &= $1.to_i <= self.atk }
    note.gsub!(/\\needdef\[([0-9]+?)\]/){ result &= $1.to_i <= self.def }
    note.gsub!(/\\needspi\[([0-9]+?)\]/){ result &= $1.to_i <= self.spi }
    note.gsub!(/\\needagi\[([0-9]+?)\]/){ result &= $1.to_i <= self.agi }
    note.gsub!(/\\limitlv\[([0-9]+?)\]/){ result &= $1.to_i >= self.level }
    note.gsub!(/\\limithp\[([0-9]+?)\]/){ result &= $1.to_i >= self.hp }
    note.gsub!(/\\limitmp\[([0-9]+?)\]/){ result &= $1.to_i >= self.mp }
    note.gsub!(/\\limitmhp\[([0-9]+?)\]/){ result &= $1.to_i >= self.maxhp }
    note.gsub!(/\\limitmmp\[([0-9]+?)\]/){ result &= $1.to_i >= self.maxmp }
    note.gsub!(/\\limitatk\[([0-9]+?)\]/){ result &= $1.to_i >= self.atk }
    note.gsub!(/\\limitdef\[([0-9]+?)\]/){ result &= $1.to_i >= self.def }
    note.gsub!(/\\limitspi\[([0-9]+?)\]/){ result &= $1.to_i >= self.spi }
    note.gsub!(/\\limitagi\[([0-9]+?)\]/){ result &= $1.to_i >= self.agi }
    return result
  end
end
class Game_Actor < Game_Battler
  include XRXSV24
end
