#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ DEP 無効化 - KGC_DisableDEP ◆ XP/VX ◆
#_/    ◇ Last update : 2009/08/23 ◇
#_/----------------------------------------------------------------------------
#_/  たまに VX が落ちる原因となる DEP を無効化します。
#_/  一応、XP/VX のどちらでも使用することができます。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

$imported = {} if $imported == nil
$imported["DisableDEP"] = true

module DEP
  #--------------------------------------------------------------------------
  # ○ DEP 変更可能判定
  #    ※ DEP を弄れるのは XP SP3 と Vista SP1 以降
  #--------------------------------------------------------------------------
  def self.dep_changeable?
    api = Win32API.new('kernel32', 'GetVersionExA', 'p', 'l')
    ver = [148, "\0"].pack('La144')  # OSVERSIONINFO
    api.call(ver)
    ver = ver.unpack('L5A*')

    return true if ver[1] >= 7     # 7 以降なら OK

    if ver[5] =~ /Service Pack (\d)/
      sp = $1.to_i
    else
      sp = 0
    end

    if ver[1] == 6                    # Vista
      return true if sp >= 1            # SP1 以降なら OK
    elsif ver[1] == 5 && ver[2] == 1  # XP
      return true if sp >= 3            # SP3 以降なら OK
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ○ DEP 無効化
  #--------------------------------------------------------------------------
  def self.disable
    return unless dep_changeable?

    api = Win32API.new('kernel32', 'SetProcessDEPPolicy', 'l', 'l')
    api.call(0)
  end
  #--------------------------------------------------------------------------
  # ○ DEP 有効判定
  #--------------------------------------------------------------------------
  def self.enabled?
    return false unless dep_changeable?

    api_pid   = Win32API.new('kernel32', 'GetCurrentProcessId', 'v', 'l')
    api_hproc = Win32API.new('kernel32', 'OpenProcess', 'lll', 'l')
    api_close = Win32API.new('kernel32', 'CloseHandle', 'l', 'l')
    api_dep   = Win32API.new('kernel32', 'GetProcessDEPPolicy', 'lpp', 'l')

    hProcess = api_hproc.call(0x1F0FFF,  # PROCESS_ALL_ACCESS
      1, api_pid.call)
    flags     = [0].pack('L')
    permanent = [0].pack('L')
    api_dep.call(hProcess, flags, permanent)
    api_close.call(hProcess)

    flags = flags.unpack('L')[0]
    return ( (flags & 1) != 0 )
  end
end

DEP.disable
