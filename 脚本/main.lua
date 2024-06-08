-- ϵͳʱ��
time = systemTime
-- https://gitee.com/boluokk/e7-helper/raw/master/release/ ����(��������)
-- https://gitcode.net/otato001/e7hepler/-/raw/master/
-- https://gitea.com/boluoii/e7Helper/raw/branch/master/

-- �ȸ�Դ
update_source_arr = {
  'https://gitee.com/boluokk/e7_helper/raw/master/',
  'https://gitea.com/boluoii/e7Helper/raw/branch/master/',
  'https://gitcode.net/otato001/e7hepler/-/raw/master/',
}
update_source = table.remove(update_source_arr, math.random(1, #update_source_arr))
update_source_fallback = table.remove(update_source_arr, math.random(1, #update_source_arr))
click_start_tip = '���star, �����ߵ�������'
-- apk level ����
is_apk_old = function() return getApkVerInt() < 0 end
apk_old_warning = "��ô��������" .. getApkVerInt()
release_date = "03.31 11:13"
release_content = '�°澺����UI�޸�, �ȸ�����'
-- ��ȡworkPath
root_path = getWorkPath() .. '/'
-- ��ֹ�ȸ���
hotupdate_disabled = true
-- log ��־��ʾ�����½�
-- true stoat ��ӡ
-- false print ��ӡ
logger_display_left_bottom = true
-- ��ӡ��ǰִ�е�������(�����ĳ��ͼɫ��)
detail_log_message = not logger_display_left_bottom
-- ���ò���
disable_test = true
-- ��ͼ�ӳ�
capture_interval = 0
-- ��Ϸ����ʶͼ���
game_running_capture_interval = 3
-- ���������ļ�����
fileNames = {'config.txt', 
             'fightConfig.txt', 
             'bagConfig.txt', 
             'functionSetting.txt', 
             'advSetting.txt'}
-- ����ӳ�
tap_interval = 0
-- app����ʱ��
app_is_run = time()
--server pkg name
server_pkg_name = {
  ["����"] = 'com.zlongame.cn.epicseven',
  ['B��'] = 'com.zlongame.cn.epicseven.bilibili',
  ['���ʷ�'] = 'com.stove.epic7.google',
}
-- ��ǰ������
current_server = "���ʷ�"
-- wait ���
wait_interval = .3
-- �Ƿ��쳣�˳�
is_exception_quit = false
-- UI�������
ui_config_finish = false
-- �Ѿ��������Ϸ��ҳ
isBack = false
-- loggerID
logger_ID = nil
-- ��ȡ״̬��
sgetNumberConfig = function (key, defval) return tonumber(getNumberConfig(key, defval)) end
-- �Ƿ���ˢ��ǩ
is_refresh_book_tag = sgetNumberConfig('is_refresh_book_tag', 0)
-- ��ǰ����
current_task_index = sgetNumberConfig("current_task_index", 0)
-- �쳣�˳�����
exception_count = sgetNumberConfig('exception_count', 1)
-- ��ǰ�˺�����
current_task = {}
-- �����Ϸ״̬ 10s
check_game_status_interval = 10 * 1000
-- ���ͼɫʶ��ʱ��
getMillisecond = function (secound) return secound * 1000 end
-- ��λ��
check_game_identify_timeout = getMillisecond(15)
-- ����ssleep���
other_ssleep_interval = 1
-- ��������Ϣʱ��
single_task_rest_time = 5
-- ��Դ˵���ֲ��ַ
open_resource_doc = 'https://boluokk.github.io/e7Helper/'
-- ȫ�ֹؿ�����(���������ʱ����ʾ: ������ 1/100)
global_stage_count = 0
-- ��ӡ������Ϣ
print_config_info = false
-- �ֱ��� 720x1280
-- ����   1280x720
local disPlayDPI = 320
displaySizeWidth, displaySizeHeight = getDisplaySize()
require("point")
require('path')
require("util")
require("userinterface")
require("test")
-- �쳣����
setEventCallBack()
-- �û������Ƿ�ر��ȸ�
if not hotupdate_disabled then
  hotupdate_disabled = uiConfigUnion({'advSetting.txt'})['�ر��ȸ�']
end

local scriptStatus = sgetNumberConfig("scriptStatus", 0)
-- �ȸ��¿�ʼ
if scriptStatus == 0 then
  consoleInit()
  initLocalState()
  initPostCheckProcess()
  slog(click_start_tip, 3)
  slog('�������ʱ��: '..release_date)
  slog('�����������: '..release_content or '����')
  if not hotupdate_disabled then hotUpdate() end
  sui.show()
else
  setNumberConfig("scriptStatus", 0)
  -- ���ر�������
  current_task = uiConfigUnion(fileNames)
  local configReTryCount = current_task['���Դ���'] or 5
  -- ����쳣�رսű�
  -- �˳���Ϸ����������Ϸ ?
  if exception_count > configReTryCount then 
    slog('����'..configReTryCount..'���쳣�˳�') 
    setNumberConfig("exception_count", 1) 
    exit() 
  else
    setNumberConfig("exception_count", exception_count + 1)
  end 
  if is_refresh_book_tag == 1 then
    path.ˢ��ǩ(sgetNumberConfig("refresh_book_tag_count", 0))
  elseif is_refresh_book_tag == 2 then
    path.��3�ǹ���()
  else
    path.��Ϸ��ʼ()
  end
end