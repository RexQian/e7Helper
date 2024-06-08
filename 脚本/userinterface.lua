sui = {}
-- ui�¼�
suie = {}
parentUID = '����ʷʫ���� '..release_date..' '..displaySizeWidth..'x'..displaySizeHeight
grindUID = 'ˢͼ����'
bagUID = '������������'
functionSettingUID = '��������ҳ'
AdvSettingUID = '�߼�����ҳ'

-- bin: bid��bname
addButton = function (bin, partid)
  partid = partid or parentUID
  ui.addButton(partid, bin, bin)
  ui.setOnClick(bin, 'suie.'..bin..'()')
end
setButton = function (bin, w, h)
  w = w or 100
  h = h or 100
  -- ����¼�����
  ui.setButton(bin, bin, w, h)
end
newLayout = function (pid)
  pid = pid or parentUID
  ui.newLayout(pid, 720, -2)
end
newRow = function (pid)
  pid = pid or parentUID
  ui.newRow(pid, uuid())
end
addTab = function (pin, pid)
  pid = pid or parentUID
  ui.addTab(pid, pin, pin)
end
addTabView = function (cid)
  ui.addTabView(parentUID,cid)
end
addTextView = function (text, pid)
  pid = pid or parentUID
  ui.addTextView(pid,text,text)
end
addRadioGroup = function (id, data, pid)
  pid = pid or parentUID
  if type(data) ~= 'table' then data = {data} end
  ui.addRadioGroup(pid,id,data,0,-1,70,true)
end
addCheckBox = function (id, selection, pid, defaluValue)
  pid = pid or parentUID
  ui.addCheckBox(pid,id,selection, defaluValue)
end
addEditText = function (id, text, pid)
  pid = pid or parentUID
  ui.addEditText(pid,id,text)
end
saveProfile = function (path)
  ui.saveProfile(root_path..path)  
end
loadProfile = function (path)
  ui.loadProfile(root_path..path)
end
addSpinner = function (id, data, pid)
  pid = pid or parentUID
  data = data or {}
  ui.addSpinner(pid, id ,data)
end
setDisabled = function (id)
  ui.setEnable(id,false)
end
setEnable = function ()
  ui.setEnable(id,true)
end
dismiss = function (id) ui.dismiss(id) end
suie.�˳� = exit
suie.���� = function ()
  if not suie.����ǰ() then return end
  if print_config_info then print(current_task) exit() end
  if current_task['������־'] then logger_display_left_bottom = false detail_log_message = true end
  path.��Ϸ��ʼ()
end
suie.����ǰ = function ()
  -- ��������
  saveProfile('config.txt')
 -- �Ƿ�������������(��������, ��Ȼ������⿨��)
  if not sFileExist('bagConfig.txt') then log('����������������!') suie.������() return end
  if not sFileExist('functionSetting.txt') then log('�����ù�������!') suie.��������() return end
  -- ��ȡ�����ļ�����
  current_task = uiConfigUnion(fileNames)
  ui_config_finish = true
  dismiss(parentUID)
  return 1
end
suie.ˢ��ǩ = function ()
  if not suie.����ǰ() then return end
  path.ˢ��ǩ(sgetNumberConfig("refresh_book_tag_count", 0))
end
suie.ʹ��˵�� = function ()
  runIntent({
    ['action'] = 'android.intent.action.VIEW',
    ['uri'] = open_resource_doc
  })
  exit()
end
suie.ˢͼ���� = function ()
  sui.showNotMainUI(sui.showGrindSetting)
end
suie.ˢ��UI = function ()
  for i,v in pairs(fileNames) do sdelfile(v) end
  reScript()
end
suie.�������� = function ()
  sui.showNotMainUI(sui.showFunctionSetting)
end
suie.�߼����� = function ()
  sui.showNotMainUI(sui.showAdvSetting)
end
suie.�������ñ��� = function ()
  saveProfile('functionSetting.txt')
  suie.��������ȡ��()
end
suie.��������ȡ�� = function ()
   sui.hiddenNotMainUI(functionSettingUID)
end
suie.�߼�����ȡ�� = function ()
  sui.hiddenNotMainUI(AdvSettingUID)
end
suie.�߼����ñ��� = function ()
  saveProfile('advSetting.txt')
  suie.��������ȡ��()
end
suie.ˢͼ����ȡ�� = function ()
  sui.hiddenNotMainUI(grindUID)
end
suie.ˢͼ���ñ��� = function ()
  saveProfile('fightConfig.txt')
  suie.ˢͼ����ȡ��()
end
suie.������ = function ()
  sui.showNotMainUI(sui.showBagSetting)
end
suie.��������ȡ�� = function ()
  sui.hiddenNotMainUI(bagUID)
end
suie.�������ñ��� = function ()
  saveProfile('bagConfig.txt')
  suie.��������ȡ��()
end
suie.��3�ǹ��� = function ()
  if not suie.����ǰ() then return end
  path.��3�ǹ���()
end
suie.������� = function ()
  if not suie.����ǰ() then return end
  path.�������()
end
suie.�ֶ��ȸ� = function ()
  local hotUpdateUrl = ui.getValue("�ֶ��ȸ���ַ")
  if hotUpdateUrl and hotUpdateUrl:find('http') then
    update_source = hotUpdateUrl
    hotUpdate()
  else
    log('�ȸ���ַ��ʽ����!')
  end
end
-- ��ҳ
sui.show = function ()
  newLayout()
  newRow()
  -- ��Դ��Ϣ
  addTextView('��ѿ�Դ��������(���·�ʹ��˵�� or ��Ⱥ)\n'..
              'QQȺ:206490280      '..
              'QQƵ����:24oyp5x92q')
  newRow()
  -- ������
  addTextView('������: ')
  local servers = ui_option.������
  addRadioGroup('������', servers)
  newRow()
  -- �ճ�������
  local selections = ui_option.����
  for i,v in pairs(selections) do
    addCheckBox(v, v)
    if i % 3 == 0 then newRow() end
  end
  newRow()
  addTextView('ÿ��')
  addEditText('���м��ʱ��', '120')
  addTextView('����, ѭ��һ��')
  newRow()
  addButton('ʹ��˵��')
  addTextView(('|'))
  addButton('����')
  addButton('�˳�')
  newRow()
  addButton('ˢ��UI')
  addTextView(('|'))
  addButton('������')
  addButton('ˢͼ����')
  newRow()
  addButton('�߼�����')
  addTextView(('|'))
  addButton('�������')
  addButton('��������')
  newRow()
  addButton('XXX')
  addTextView('|')
  addButton('ˢ��ǩ')
  addButton('��3�ǹ���')

  ui.setBackground("ʹ��˵��","#ffe74032")
  ui.setBackground("�������","#ff3bceb3")
  ui.setBackground("��3�ǹ���","#ff3bceb3")
  ui.setBackground("ˢ��ǩ","#ff3bceb3")
  ui.show(parentUID, false)

  -- load config
  loadProfile('config.txt')
  wait(function ()
    if ui_config_finish then return true end
  end, .05, nil, true)
end
-- ս������
sui.showGrindSetting = function ()
  newLayout(grindUID)
  -- addButton('ˢͼ����', grindUID)
  local passAll = ui_option.ս������
  for i,v in pairs(passAll) do
    local cur = i..''
    if cur:includes({1,3,5,6,7}) then
      addCheckBox(v, v, grindUID)
    else
      addCheckBox(v, v, grindUID)
      -- ��ʱ����
      -- todo
      setDisabled(v)
    end
    if i % 4 == 0 then
      newRow(grindUID)
    end
  end
  newRow(grindUID)
  addTextView('�����ж���:', grindUID)
  addRadioGroup('�����ж�������', ui_option.�����ж�������, grindUID)
  newRow(grindUID)
  addCheckBox('�����ظ�ս��', '�����ظ�ս��', grindUID, true)
  newRow(grindUID)
  addTextView('�ַ�: ', grindUID)
  addSpinner('�ַ�����', ui_option.�ַ��ؿ�����, grindUID)
  addSpinner('�ַ�����', ui_option.�ַ�����, grindUID)
  addTextView('��', grindUID)
  addEditText('�ַ�����', '100', grindUID)
  addTextView('��', grindUID)
  newRow(grindUID)
  addTextView('�Թ���', grindUID)
  newRow(grindUID)
  addTextView('�����̳��', grindUID)
  addSpinner('�����̳����', ui_option.�����̳�ؿ�����, grindUID)
  addSpinner('�����̳����', ui_option.�����̳����, grindUID)
  addTextView('��', grindUID)
  addEditText('�����̳����', '100', grindUID)
  addTextView('��', grindUID)
  newRow(grindUID)
  addTextView('��Ԩ��', grindUID)
  newRow(grindUID)
  newRow(grindUID)
  addTextView('��ǣ�', grindUID)
  addEditText('��Ǵ���', '100', grindUID)
  addTextView('��', grindUID)
  newRow(grindUID)
  addTextView('���', grindUID)
  addSpinner('�ָ��', ui_option.�ָ��, grindUID)
  addTextView('ָ��', grindUID)
  addSpinner('�����', ui_option.�����, grindUID)
  addTextView('��', grindUID)
  addEditText('�����', '100', grindUID)
  addTextView('��', grindUID)
  newRow(grindUID)
  addTextView('�����ظ�ˢ��', grindUID)
  addEditText('�����ظ�ˢ����', '100', grindUID)
  newRow(grindUID)
  addButton('ˢͼ���ñ���', grindUID)
  addButton('ˢͼ����ȡ��', grindUID)
  ui.show(grindUID, false)
  loadProfile('fightConfig.txt')
end
sui.showNotMainUI = function (fun)
  -- ��������
  saveProfile('config.txt')
  dismiss(parentUID)
  fun()
end
sui.hiddenNotMainUI = function (hiddenID)
  dismiss(hiddenID)
  sui.show()
end
-- ��������
sui.showBagSetting = function ()
  newLayout(bagUID)
  addTextView('���ﱳ��', bagUID)
  newRow(bagUID)
  -- Ĭ��: B C D
  for i,v in pairs(ui_option.���Ｖ��) do
    if v:includes({'B', 'C', 'D'}) then
      addCheckBox(v, v, bagUID, true)
    else
      addCheckBox(v, v, bagUID)
    end
  end
  newRow(bagUID)
  addTextView('����-��ȡ���ȶ�', bagUID)
  newRow(bagUID)
  addRadioGroup('������ȡ���ȶ�', ui_option.������ȡ���ȶ�, bagUID)
  newRow(bagUID)
  addTextView('װ������', bagUID)
  newRow(bagUID)
  -- Ĭ�ϣ�
  for i,v in pairs(ui_option.װ������) do
    if v:includes({'һ��', '�߼�', 'ϡ��'}) then
      addCheckBox(v, v, bagUID, true)
    else
      addCheckBox(v, v, bagUID)
    end
  end
  newRow(bagUID)
  for i,v in pairs(ui_option.װ���ȼ�) do
    if v:includes({'28', '42', '57', '71', '72'}) then
      addCheckBox(v, v, bagUID, true)
    else
      addCheckBox(v, v, bagUID)
    end
    if i % 4 == 0 then
      newRow(bagUID)
    end
  end
  newRow(bagUID)
  for i,v in pairs(ui_option.װ��ǿ���ȼ�) do
    if v:includes({'+0', '9'}) then
      addCheckBox(v, v, bagUID, true)
    else
      addCheckBox(v, v, bagUID)
    end
    if i % 4 == 0 then
      newRow(bagUID)
    end
  end
  newRow(bagUID)
  addTextView('��������', bagUID)
  newRow(bagUID)
  for i,v in pairs(ui_option.�����Ǽ�) do 
    if v:includes({'1', '2', '3'}) then
      addCheckBox(v, v, bagUID, true)
    else
      addCheckBox(v, v, bagUID)
    end
    if i % 7 == 0 then
      newRow(bagUID)
    end
  end
  newRow(bagUID)
  for i,v in pairs(ui_option.����ǿ��) do
    if v:includes({'+0', '10'}) then
      addCheckBox(v, v, bagUID, true)
    else
      addCheckBox(v, v, bagUID)
    end
    if i % 4 == 0 then
      newRow(bagUID)
    end
  end
  newRow(bagUID)
  addTextView('Ӣ�۵ȼ�', bagUID)
  newRow(bagUID)
  for i,v in pairs(ui_option.Ӣ�۵ȼ�) do 
    if v:includes({'1', '2', '3'}) then
      addCheckBox(v, v, bagUID, true)
    else
      addCheckBox(v, v, bagUID)
    end
    if i % 7 == 0 then
      newRow(bagUID)
    end
  end
  newRow(bagUID)
  addButton('�������ñ���', bagUID)
  addButton('��������ȡ��', bagUID)
  ui.show(bagUID, false)
  loadProfile('bagConfig.txt')
end
-- ��������
sui.showFunctionSetting = function ()
  newLayout(functionSettingUID)
  addTextView('<ˢ��ǩ����>', functionSettingUID)
  newRow(functionSettingUID)
  local tag = ui_option.ˢ��ǩ����
  addTextView('��ǩ: ', functionSettingUID)
  for i,v in pairs(tag) do 
    if i == 3 then
      addCheckBox(v, v, functionSettingUID)
    else 
      addCheckBox(v, v, functionSettingUID, true)
      ui.setEnable(v, false)
    end
  end
  newRow(functionSettingUID)
  -- ��װ
  local level = ui_option.��װ�ȼ�
  addTextView('��װ��ͣ: ', functionSettingUID)
  for i,v in pairs(level) do 
    addCheckBox('��װ��ͣ-'..v, v, functionSettingUID)
  end
  -- �����޸�����
  newRow(functionSettingUID)
  addTextView('����:', functionSettingUID)
  addEditText('���´���', '333', functionSettingUID)
    -- ��Ҫ���ü�����������
  newRow(functionSettingUID)
  addTextView('<����������>', functionSettingUID)
  newRow(functionSettingUID)
  addCheckBox('Ҷ����Ʊ', 'Ҷ����Ʊ', functionSettingUID, true)
  addTextView('ˢ�½�ս����:', functionSettingUID)
  addEditText('��ս����', '30', functionSettingUID)
  newRow(functionSettingUID)
  addTextView('ÿ�ܽ���: ', functionSettingUID)
  addRadioGroup('������ÿ�ܽ���', ui_option.������ÿ�ܽ���, functionSettingUID)
  newRow(functionSettingUID)
  addTextView('����: ', functionSettingUID)
  addRadioGroup('����������', ui_option.����������, functionSettingUID)
  -- local mission = {'ʥ��', '̽��', '�ַ�', 'ս��'}
  -- addTextView('��ǲ����:')
  -- addRadioGroup('��ǲ����', mission)
  newRow(functionSettingUID)
  addTextView('<��������>', functionSettingUID)
  newRow(functionSettingUID)
  local teamMission = ui_option.��������
  for i,v in pairs(teamMission) do
    if i % 4 == 0 then newRow(functionSettingUID) end
    addCheckBox(v, v, functionSettingUID, true)
  end
  newRow(functionSettingUID)
  addTextView('���ž�����', functionSettingUID)
  addRadioGroup('���ž�������', ui_option.���ž�������, functionSettingUID)
  newRow(functionSettingUID)
  addTextView('<������������>', functionSettingUID)
  newRow(functionSettingUID)
  addTextView('��3�ǹ���:', functionSettingUID)
  addRadioGroup('��3�ǹ�������', ui_option.��2�ǹ�������, functionSettingUID)
  newRow(functionSettingUID)
  addEditText('��3�ǹ�������','100', functionSettingUID)
  addTextView('��', functionSettingUID)
  addTextView('����ǰ��������!', functionSettingUID)

  newRow(functionSettingUID)
  addButton('�������ñ���', functionSettingUID)
  addButton('��������ȡ��', functionSettingUID)


  ui.show(functionSettingUID, false)
  loadProfile('functionSetting.txt')
end
-- �߼�����
sui.showAdvSetting = function ()
  newLayout(AdvSettingUID)
  addTextView('�������Դ��� ', AdvSettingUID)
  addEditText('���Դ���', '5', AdvSettingUID)
  -- newRow(AdvSettingUID)
  -- addTextView('qq��Ϣ֪ͨ ', AdvSettingUID)
  -- addEditText('���Դ���', '5', AdvSettingUID)
  newRow(AdvSettingUID)
  addTextView('�ֶ��ȸ���ַ ', AdvSettingUID)
  addEditText('�ֶ��ȸ���ַ', 'https://gitcode.net/otato001/e7hepler/-/raw/master/', AdvSettingUID)
  newRow(AdvSettingUID)
  addButton('�ֶ��ȸ�', AdvSettingUID)
  newRow(AdvSettingUID)
  addCheckBox('������־', '������־', AdvSettingUID)
  addCheckBox('�ر��ȸ�', '�ر��ȸ�', AdvSettingUID)
  newRow(AdvSettingUID)
  addTextView('qq��Ϣ֪ͨ(��������ַ) ', AdvSettingUID)
  addEditText('qq��Ϣ֪ͨ', '', AdvSettingUID)
  newRow(AdvSettingUID)
  addTextView('qq��Ϣ���͸�˭(QQ��) ', AdvSettingUID)
  addEditText('qq��Ϣ���͸�˭', '', AdvSettingUID)
  newRow(AdvSettingUID)
  addButton('�߼����ñ���', AdvSettingUID)
  addButton('�߼�����ȡ��', AdvSettingUID)
  ui.show(AdvSettingUID, false)
  loadProfile('advSetting.txt')
end