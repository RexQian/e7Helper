path = {}

path.��Ϸ��ʼ = function ()
	path.��Ϸ��ҳ()
	path.�������()
end

-- isBack: ͨ����back������
path.��Ϸ��ҳ = function ()
	current_server = getUIRealValue('������', '������')
	local isBack = true
	if not sAppIsRunning(current_server) or not sAppIsFront(current_server) then
		open(server_pkg_name[current_server])
	end
	setControlBarPosNew(0, 1)
	local clickTarget = {'����ǩ����������', '����ǩ����������2', '��������X', '������������ս����',
										 	 '��������ս��', '��������', '�����̵�ȡ��', '���ʷ�����', 
											 '��Ӣ�ۻ�ȡȷ��', '����ȡ��', '�����д���'}
	if wait(function ()
		-- ������ά����
		if findOne('����������ά����') then return 'exit' end
		if findOne('������ҳRank') and not longAppearMomentDisAppear('������ҳRank', nil, nil, 2) then
			return 1
		end
		if findOne('������¼����ʷʫ') then isBack = false end
		if not findTapOnce(clickTarget, {keyword = {'����', 'ȡ��'}}) then
			if not isBack then
				stap(point.����)
			else
				back()
			end
		end
	end, 1, 7 * 60) == 'exit' then
		slog('������ά����...')
		exit()
	end
end

path.������� = function ()
	local allTask = table.filter(ui_option.����, function (v)
		return not v:includes({'����ǩ��',
		'���Ž���',
		'���ž���'})
	end)
	local curTaskIndex = sgetNumberConfig("current_task_index", 0)
	local intervalTime = current_task['���м��ʱ��']
	repeat
		for i,v in pairs(allTask) do
			if i > curTaskIndex and current_task[v] then
				-- 0 ��ʾ�쳣
				-- 1 ���� nil ��ʾ ok
				-- 2 ��ʾ����
				if path[v]() == 2 then path.��Ϸ��ҳ() path[v]() end
				slog(v)
				sendCloudMessage(v..'�˳�ǰ��ͼ')
				setNumberConfig("exception_count", 1)
				path.��Ϸ��ҳ()
			end
			setNumberConfig('current_task_index', i)
		end
		-- ��ʼ��Ϣ
		sendCloudMessage('������ɿ�ʼ�һ�..')
		if intervalTime ~= 0 then
			local intervalSecTime = (intervalTime * 60 * 1000) + time()
			wait(function () log("�һ�ʱ��: "..getTime(intervalSecTime)) end, 1, intervalTime * 60)
		end
		setNumberConfig('current_task_index', 0)
	until intervalTime == 0
end

path.�������� = function ()
	wait(function ()
		stap(point.����)
				ssleep(1)
			if not findOne('������ҳRank') then return 1 end
	end)
	longAppearAndTap('����������ʿ��', nil, {447,47}, 2)
	if current_task.����ǩ�� then path.����ǩ��() end
	if current_task.���ž��� then path.���ž���() end
	if current_task.���Ž��� then path.���Ž���() end
	if current_task.��ս���� then path.��ս����() end
	if current_task.��������ս then path.��������ս() end
end

path.��������ս = function ()
	wait(function ()
		stap({1112,209})
		return findOne("304|413|FFFFFF,316|430|FFFFFF")
	end)
	if findTap('��������ս') then
		for i=1,2 do
			wait(function ()
				stap({338,116})
				return findOne('��������׼��ս��')
			end)
			untilTap('��������׼��ս��')
			-- untilTap('��������ѡ�����')
			if not wait(function () return findTap('��������ѡ�����') end, .1, 2) then
				break
			end
			untilTap('����������ɶ���')
			untilAppear('��������ս����ʼ')
			-- ��Ӷ���
			wait(function ()
				stap({164,653})
				return not findOne("37|480|FFFFFF,353|480|FFFFFF,668|479|FFFFFF")
			end)
			untilTap('��������ս����ʼ')
			wait(function ()
				stap({1079,31})
				return findOne('��������ȫ������')
			end, .5, 60)
			longDisappearTap('��������ȫ������', nil, {641,618}, 1)
			untilTap('�����������ȷ��')
		end
	end
end

path.��ս���� = function ()
	if findTap('��ս����') then
		untilTap('��ս����ȷ��')
		wait(function ()
			stap({34,31})
			return wait(function ()
				return findOne('��ʿ�����ʺ�')
			end, .1, 2)
		end)
	end
end

path.����ǩ�� = function ()
	if findTap('������ʿ��ǩ��') then
		wait(function ()
			stap({509,35})
			if findOne('����������ʿ��') then return 1 end
		end)
	end
end

path.���ž��� = function ()
	wait(function ()
		stap({1090,414})
		if findOne("319|331|28B6FF,314|344|2DC3F4") then
			return 1
		end
	end)
	-- ���
	-- ����֤��
	-- ������
	local giveType = current_task.���ž�������
	if giveType == 0 then
		findTap('������Ҿ���')
	elseif giveType == 1 then
		findTap('��������֤�ݾ���')
	elseif giveType == 2 then
		findTap('������Ҿ���')
		wait(function ()
			stap({515,40})
			if findOne('����������ʿ��') then return 1 end
		end)
		findTap('��������֤�ݾ���')
	end
	wait(function ()
		stap({515,40})
		if findOne('����������ʿ��') then return 1 end
	end)
end

path.���Ž��� = function ()
	wait(function ()
		stap({1114,698})
		if findOne('������ʿ��ÿ������', {sim = 1}) then return 1 end
	end)
	-- �Ϸ�С��㴦��, ���ʶ���...���Թ���
	if findTap('����ÿ��ÿ��С����', {rg = {437,140,987,212}, sim = .98}) then
		wait(function ()
			stap({600,81})
			if findOne('������ʿ��ÿ������', {sim = 1}) then return 1 end
		end)
	end
	-- �м���ȡ����
	-- ����ֻ�û���һ��, Ҳ����ֻ����ҳ
	for i=1,2 do
		wait(function ()
			if findTap('������ʿ��������ȡ', {rg = {866,255,990,722}}) then
				wait(function ()
					stap({424,30})
					if findOne('������ʿ��ÿ������', {sim = 1}) then return 1 end
				end)
			else
				return 1
			end
		end)
		if i == 1 then sswipe({574,674}, {574,287}) ssleep(.5) end
	end
end

-- 0.66 ��Լ
-- 0.17 ����
path.ˢ��ǩ = function (rest, isSingle)
	rest = rest or 0
	local startCheck = {'���������̵��һ����Ʒ',
											'���������̵�ڶ�����Ʒ',
											'���������̵��������Ʒ',
											'���������̵���ĸ���Ʒ'}
	if not isSingle then
		setNumberConfig("is_refresh_book_tag", 1)
	end
	path.��Ϸ��ҳ()
	local tapPoint1 = point['�����̵�0']
	local tapPoint2 = point['�����̵�1']
	wait(function ()
		stap(tapPoint1)
		stap(tapPoint2)
		ssleep(1)
		if not findOne('������ҳRank') then return 1 end
	end)
	log('���������̵�')
	untilAppear('���������̵���������')
	-- ��һ����Ʒ������(bug)
	untilAppear(startCheck)
	-- ��ʼ�һ�ˢ����ǩ��
	-- ���������̵�������ǩ
	-- ���������̵���Լ��ǩ
	local target = {}
	local g1 = sgetNumberConfig("g1", 0)
	local g2 = sgetNumberConfig("g2", 0)
	local g3 = sgetNumberConfig("g3", 0)
		-- ��װ��ͣ
	if current_task['��װ��ͣ-55��'] then table.insert(target, '55��װ') end
	if current_task['��װ��ͣ-70��'] then table.insert(target, '70��װ') end
	if current_task['��װ��ͣ-85��'] then table.insert(target, '85��װ') end
	table.insert(target, '����')
	table.insert(target, '��ǩ')
	if current_task['������ǩ'] then table.insert(target, '������ǩ') end

	local refreshCount = current_task['���´���'] or 334
	local enoughResources = true
	local msg
	local newRg
	local pos, countTarget, curFindCount -- ��ǰʶ�����, ��� 4
	local allMoney = 0
	msg = ''
	-- openHUD(msg, 'ˢ��ǩ')
	for i=1,(refreshCount + 1) do
		curFindCount = 1
		if i > rest then
			while curFindCount <= 6 do
			 	pos, countTarget= findOne(target, {rg = {540,70,669,718}})
				if pos then         
					if countTarget:find('��װ') then
						-- do something
						-- �ʼ�֪ͨ?
						-- qq֪ͨ?
						slog('���� -> '..countTarget)
						enoughResources = false
						break 
					end
					newRg = {1147, pos[2] - 80, 1226, pos[2] + 80}
					untilTap('���������̵깺��', {rg = newRg})
					-- �ټ��һ��, �������ǩ?
					-- ���ص���������ʶ��
					untilAppear('���������̵깺��1')
					if wait(function ()
						return findOne(countTarget)
					end, .3, 5) then
						-- ȷ������ǩ
						untilTap('���������̵깺��1')
					else
						-- ��������ˢ�´���, ȡ��
						log('����ǩ, ׼��ȡ������..')
						curFindCount = 0
						untilTap('�����̵�ȡ��')
					end
					-- �ȴ�������Ч��ʧ, �ᵼ��������
					longDisappearTap(countTarget, {rg = {531,48,649,155}}, nil, 1.5, 5)
					if curFindCount == 0 then
						wait(function ()
							sswipe({932,138}, {932,600})
							ssleep(1)
							return findOne(startCheck)
						end)
					end
				end
				-- ��Դ�Ƿ�ľ�
				wait(function ()
					local r1, r2 = findOne({'���������̵깺����Դ����', 
																	'���������̵���������', 
																	'����һ���̵�'}, {sim = 1})
					if r2 == '���������̵���������' then
						-- ͳ�ƻ����Ʒ����
						if countTarget and curFindCount ~= 0 then
							if countTarget == '����' then
								g1 = g1 + 1
								allMoney = allMoney + 280
								setNumberConfig("g1", g1)
							elseif countTarget == '��ǩ' then
								g2 = g2 + 1
								allMoney = allMoney + 184
								setNumberConfig("g2", g2)
							elseif countTarget == '������ǩ' then
								g3 = g3 + 1
								allMoney = allMoney + 18
								setNumberConfig("g3", g3)
							end
						end
						return 1 
					end
					if r2 == '���������̵깺����Դ����' or r2 == '����һ���̵�' then 
						-- ��ʾ�ж���û������
						enoughResources = false
						if countTarget then
							slog('��Ҳ��㵼��, ����Ʒû�й���ɹ�: '..countTarget)
						end
						return 1 
					end
				end)
				-- д���ж������ܻ�connection���»���ʧЧ
				if curFindCount == 3 and enoughResources then
					wait(function ()
						sswipe({858,578}, {858,150})
						return findOne({'�����̵����һ����Ʒ', '�����̵���������Ʒ', '�����̵����������Ʒ'})
					end)
				end
				curFindCount = curFindCount + 1
			end
			if i > refreshCount then path.��Ϸ��ҳ() break end
			msg = 'ˢ�´���: '..i..'/'..refreshCount..
						'\n�ѻ���שʯ: '..(i * 3)..
						'\n�ѻ��ѽ��: '..allMoney..'K'..
						'\n����: '..(g1 * 50)..'('..string.format("%.5f", g2/i*100)..'%)'..
						'\n��Լ: '..(g2 * 5)..'('..string.format("%.5f", g2/i*100)..'%)'.. 
						'\n����: '..(g3 * 5)..'('..string.format("%.5f", g3/i*100)..'%)'
			openHUD(msg, 'ˢ��ǩ')
			if not enoughResources then path.��Ϸ��ҳ() break end
			slog('\n'..msg, nil, true)
			-- ������粻�ûᵼ�����ε��, �ĳ� sim = 1
			untilTap('���������̵���������', {sim = 1})
			untilTap('���������̵깺��ȷ��')
			untilAppear('���������̵��һ����Ʒ', {sim = .98}) ssleep(1)
			setNumberConfig("exception_count", 1)
		end
		setNumberConfig("refresh_book_tag_count", i)
	end
	closeHUD()
end

path.RTA���� = function ()
	wait(function ()
		stap(point.������)
		ssleep(1)
		if not findOne('������ҳRank') then return 1 end
	end)
	untilTap('ѡ��RTA')

	local r1, r2
	wait(function ()
		stap({386,17})
		r1, r2 = findOne({'����5���ʺ�'})
		if r1 then return 1 end
	end)
	log('����RTA')

	-- �л�������
	wait(function ()
		if findOne('RTA����') then
			return 1
		end
		stap({1046,384})
	end)

	-- ѭ��ִ������
	-- ������ֲ鿴���� ����
	-- ������ֻ��Ҫ���10�� ����Ϊ12��
	local moreClickCount = 0
	repeat
		wait(function ()
			-- ִ���»�
			sswipe({860,600}, {860,100})
			ssleep(2)
			findTap({'RTA�����鿴����', 'RTA�����鿴����_2'})
			return 1
		end)
		moreClickCount = moreClickCount + 1
	until(moreClickCount > 12)

end

path.ѡ�������� = function ()
	wait(function ()
		stap(point.������)
		ssleep(1)
		if not findOne('������ҳRank') then return 1 end
	end)
	untilTap('ѡ��RTA')

	local r1, r2
	wait(function ()
		stap({386,17})
		r1, r2 = findOne({'����5���ʺ�'})
		if r1 then return 1 end
	end)
	log('����RTA')

	-- �л�������
	wait(function ()
		if findOne('RTA����') then
			return 1
		end
		stap({1046,384})
	end)

	-- �л���ѡ����
	wait(function ()
		if findOne({'ѡ��������', 'ѡ��������_2'}) then
			return 1
		end
		stap({723,164})
	end)

	-- ѭ��ִ������
	-- ������ֲ鿴���� ����
	-- ������ֻ��Ҫ���10�� ����Ϊ12��
	local moreClickCount = 0
	repeat
		wait(function ()
			-- ִ���»�
			sswipe({860,600}, {860,100})
			ssleep(2)
			findTap({'RTA�����鿴����', 'RTA�����鿴����_2'})
			return 1
		end)
		moreClickCount = moreClickCount + 1
	until(moreClickCount > 12)

end

path.ˢ������ = function ()
	local type = current_task.����������
	if type == 0 then
		path.���������()
	elseif type == 1 then
		path.������NPC()
	elseif type == 2 then
		path.������NPC()
		path.��Ϸ��ҳ()
		path.���������()
	end
end

path.��������� = function ()
	wait(function ()
		stap(point.������)
		ssleep(1)
		if not findOne('������ҳRank') then return 1 end
	end)
	-- ����������JJC��
	untilTap('ѡ��JJC')
	local r1, r2
	wait(function ()
		stap({386,17})
		r1, r2 = findOne({'����3���ʺ�',
											'����������ÿ�ܽ���ʱ��', 
											'����������ÿ����������'})
		if r1 then return 1 end
	end)
	if r2 == '����������ÿ�ܽ���ʱ��' then
		slog('������ÿ�ܽ���ʱ���˳�')
		return
	end
	if r2 == '����������ÿ����������' then
		slog('��������ȡÿ����������')
		local rankIndex = current_task['������ÿ�ܽ���'] or 0
		local pos = point.����������ÿ�ܽ���[rankIndex + 1]
		wait(function ()
			stap(pos)
			if findOne(point.����������ÿ�ܽ����ж�[rankIndex + 1]) then return 1 end
		end)
		untilTap({'������������ȡÿ�ܽ���', '���ʷ���������ȡÿ�ܽ���'})
	end
	log('���뾺����')
	-- ��������-���ֶԱ�(����ûɶ��, ȥ��)
	-- ��ս�����л�
	wait(function ()
		stap({1108,116})
		if findOne({'��������ս', '�����������ٴ���ս', '��������������ս������'}, {rg = {879,146,990,686}}) then
			ssleep(1)
			return 1
		end
	end, .5)
	-- ˢ�¶��ֵ������
	local refreshCount = current_task['��ս����']
	-- �����л���ս���ִ��������
	local buyChangeCount = true
	wait(function ()
		wait(function ()
			-- ������� ���ܶ�����
			findTap({'������������ս����', 
							 '����ս����ɾ�����ȷ��', 
							 '����ս�����ȷ��'}, {tapInterval = 1})
			stap({323,27})
			if findOne('����3���ʺ�') then
				longAppearAndTap('����3���ʺ�', nil, {323,27}, 1) 
				return 1
			end
		end)
		local enemy = wait(function ()
			return findOne('��������ս', {rg = {871,149,992,696}})
		end, .1, 1)
		if not enemy then
			if buyChangeCount then
				local result = untilAppear('����ˢ����ս', {keyword = {'���', 'ʣ��ʱ��', 'ʱ��', 'ʣ��'}})[1]
				untilTap('����ˢ����ս')
				if result.text:includes({'ʣ��ʱ��', 'ʣ��', 'ʱ��'}) then
					local availableRefreashCount = math.floor(getArenaPoints(untilAppear('������������ս����ʣ��ˢ�´���')[1].text) / 100)
					if refreshCount == 0 then
						slog('���ָ�������������!')
						untilTap('����������ȡ����������')
						return 1
					end
				end
				untilTap('�����������л�����ȷ��')
				refreshCount  = refreshCount - 1
				-- ����Ƿ�ľ�
				local tmp, v = untilAppear({'���������̵깺����Դ����', '����3���ʺ�'})
				if v == '���������̵깺����Դ����' then log('��Դ����') untilTap('�����̵�ȡ��') return 1 end
				-- ���������, ��ʼ�µ�һ��
				return
			else
				log('�޵����Լ�����')
				return 1
			end
		end
		untilTap('��������ս', {rg = {871,149,992,696}})
		untilTap('����������ս����ʼ', {sim = .98})
		if path.��������Ʊ() == 1 then return 1 end
		path.ս������()
	end, .5, nil, true)
end

path.������NPC = function ()
	wait(function ()
		stap(point.������)
				ssleep(1)
			if not findOne('������ҳRank') then return 1 end
	end)
	wait(function ()
		if not findOne('����������') then
			return 1
		end
		stap({999,339})
	end)
	untilTap('ѡ��JJC')
	local p, v
	wait(function ()
		p, v = findOne({'����������ÿ����������', '����3���ʺ�'})
		if v == '����3���ʺ�' then
			return 1
		end
		if v == '����������ÿ����������' then
			slog('��������ȡÿ����������')
			local rankIndex = current_task['������ÿ�ܽ���'] or 0
			local pos = point.����������ÿ�ܽ���[rankIndex + 1]
			wait(function ()
				stap(pos)
				if findOne(point.����������ÿ�ܽ����ж�[rankIndex + 1]) then return 1 end
			end)
			untilTap('������������ȡÿ�ܽ���')
		end
	end)
	wait(function ()
		if findOne('����NPC��ս����') then
			return 1
		end
		stap({1048,216})
	end)
	local pos
	local isSwipe = 1
	while 'qqȺ206490280' do
		local curHomePage = {"657|115|0B733C", "768|113|0557AC", "873|114|1D1D9D"}
		wait(function ()
			-- ������� ���ܶ�����
			findTap({'������������ս����', '����ս����ɾ�����ȷ��', '����ս�����ȷ��'}, {tapInterval = 1})
			stap({323,27})
			if findOne(curHomePage) then
				longAppearAndTap(curHomePage, nil, {323,27}, 1) -- 2s
				return 1
			end
		end)
		pos = findOne('����NPC��ս', {rg = {855,135,996,721}, sim = .9})
		if not pos and isSwipe == 2 then break end
		if not pos then
			isSwipe = isSwipe + 1
			wait(function ()
				sswipe({846,498}, {846,100})
				ssleep(2)
				-- �����޸���
				if findOne("780|563|421D0E,774|568|FFFFFF,770|576|D66A98,775|591|D44401") then
					return 1				
				end
			end)
		else
			-- ��ʼˢNPC
			wait(function ()
				-- ����y�ᣬ���»���������һ���������
				stap({pos[1], pos[2] + 15})
				if findOne('����3���ʺ�') then return 1 end
			end)
			untilTap('����������ս����ʼ', {sim = .98})
			-- ��Ʊ
			if path.��������Ʊ() == 1 then
				break
			end
			path.ս������()
			isSwipe = 1
		end
	end
	slog('������NPC���')
end

path.��������Ʊ = function ()
	-- Ҷ�ӹ���Ʊ
	local buyTicket = current_task['Ҷ����Ʊ']
	local t,v
	wait (function ()
		t, v = findOne({'��������������Ʊҳ��', '����Auto', 'δ��װ��������ʾ', 'δ����Ӣ��'})
		if v then return 1 else stap({615,23}) end
	end)
	-- �Ƿ�ʹ��Ҷ�Ӷһ�5��Ʊ
	-- �Ƿ�ʹ��שʯ�һ�5��Ʊ �ݲ�֧��
	if v == '��������������Ʊҳ��' and buyTicket then
		local tmp, ticketType = untilAppear({'����������Ҷ�ӹ���Ʊ', '����������שʯ����Ʊ'})
		if ticketType == '����������Ҷ�ӹ���Ʊ' then
			log('��Ʊ')
			untilTap('��������������Ʊ')
			-- ����Ƿ���
			local tmp, v = untilAppear({'���������̵깺����Դ����', '������������ս����ʼ'})
			if v == '���������̵깺����Դ����' then log('��Դ����') return 1 end
		end
		if ticketType == '����������שʯ����Ʊ' then log('ȡ����Ʊ') untilTap('����������ȡ����Ʊ') return 1 end
		untilTap('����������ս����ʼ')	
	end

	if v == '��������������Ʊҳ��' and not buyTicket then
		log('����Ʊ')
		return 1
	end

	if v == 'δ��װ��������ʾ' or v == 'δ����Ӣ��' then
		untilTap(v)
		return path.��������Ʊ()
	end
end

-- isRepeat �Ƿ�����
-- isAgent �Ƿ����
-- isActivity �Ƿ��ǻ, ���ܲ��ǲ���ֵ,���Ƿ�Χ
path.ս������ = function (isRepeat, isAgent, currentCount, isActivity)
	-- ���½�ʶ��Χ
	local rightBottomRegion = isActivity and '�������½ǻ' or '�������½�'
	log('ս����ʼ')
	-- ����auto
	-- �ӳ�ʱ�䣬ĳЩ�豸Ӳ���Ƚϲ�
	if not isRepeat then
		-- untilAppear('����Auto')
		wait(function ()
			if findOne('����Auto') then
				return 1
			end
			stap({638,31})
		end, .5, 60)
		wait(function ()
			stap('����Auto')
			ssleep(1)
			if findOne(point.����AUto�ɹ�) then return 1 end
		end, .5, 60)
	end
	
	-- �ӳ�ʱ�䣬ĳЩ�豸Ӳ���Ƚϲ�
	if isRepeat then
		wait(function ()
			if findOne('����������') then return 1 end
			ssleep(1)
			stap('����������')
		end, .5, 60)
	end
	
	-- �ȴ�����
	if not isRepeat then
		wait(function (game_stop_check)
			-- ���ֻ���һ������ǰ��ҳ, ֱ�ӵ����
			log('������.')
			-- NPC�Ի���� 
			stap({615,23})
			-- �ᵯ�����ܶ�
			if findTap({'����ս����ɾ�����ȷ��', 
									'����ս�����ȷ��'}, {tapInterval = 1}) then 
				return 1
			end
			-- �����������ÿ�ո��¼��
			game_stop_check()
		end, game_running_capture_interval, 10 * 60)
	else
		local targetKey = {'ս����ʼ', 'ȷ��', '���½���', 'ѡ�����'}
		local target = {'�������ȡ��','��������ȷ��','���������ռ䲻��', 
										'�����ж�������', '�������½�', '�������½ǻ', 
										'����ս��ʧ��', '����ս���ʺ�'} -- �������롢����������ܻ����
		local pos, targetV
		wait(function (game_stop_check)
			if currentCount then
				if isAgent then
					log('������(�г���): '..currentCount..'/'..global_stage_count)
				else
					log('������(�޳���): '..currentCount..'/'..global_stage_count)
				end
			else
				log('������..')
			end
			-- ���й���Ҫ�ֶ����,���ܵ������ҳ��
			if not isAgent then stap({483,15}) end
			if ((isAgent and findOne('�����ظ�ս�����', {keyword = {'�ظ�ս���ѽ���'}})) or
				 not isAgent) and 
				 findOne({'�������½�', '����ս��ʧ��'}, {keyword = {'ȷ��', '���½���'}}) then
				wait(function ()
					pos, targetV = findOne(target, {keyword = targetKey})
					if not pos then return end
					if targetV:includes({'���������ռ䲻��', '�����ж�������', '����ս���ʺ�'}) then
						-- ��֤���ڽ���ҳ
						if targetV == '����ս���ʺ�' and findOne('����ս���������ϱ���') then
							return
						end
						return 1
					end
					if targetV:includes({'�������½�', '����ս��ʧ��'}) then
						findTap({'�������ȡ��', '��������ȷ��'}) -- �п��ܻ��������
						stap({pos[1].l, pos[1].t})
					end
					if targetV:includes({'��������ȡ��', '��������ȷ��'}) then
						stap(pos)
					end
				end)
				return 1
			end
			-- ����һЩ����
			-- if findOne('�������޼���', {sim = .9}) then stap({903,664}) end
			if findTap('�ҵ�ͨ������') then log('���ͨ������') end
			if findTap('�������ȡ��') then log('��������ȡ��') end
			if findTap('��������ȷ��') then log('��������ȷ��') end
			-- �����������ÿ�ո��¼��
			game_stop_check()
		end, game_running_capture_interval, 9999 * 10 * 60) -- ��Ӱ��
	end
	log('ս���������')
end

path.�������� = function ()
	if not findOne('��������С�ݺ��') then log('�޳�����ȡ') return end
		wait(function ()
			stap(point.����С��)
					ssleep(1)
			if not findOne('������ҳRank') then return 1 end
		end)
		untilTap('������������')
		if wait(function ()
			stap('���������������')
			if not findOne('���������������') then return 1 end
			if findOne('�������ﱳ������') then
				path.���ﱳ������()
				return 2
			end
		end) == 2 then
		return 2
	end
	-- �����ȡһ��
	wait(function ()
		stap({34,151})
		if findOne('������������') then return 1 end
	end)
end

path.�ɾ���ȡ = function ()
	if not findOne({'�����ɾͺ��', '�����ɾͺ��2'}) then log('�޳ɾ���ȡ') return 1 end
	wait(function ()
		stap(point.�ɾ�)
				ssleep(1)
			if not findOne('������ҳRank') then return 1 end
	end)
	untilAppear('���������ܷ��·���')
	local target = {'�����������ռ�', '��������֮������Ժ', '����Ԫ��Ժ', '������������', '���������Ӱ��'}
	for i,v in pairs(target) do
		local curTarget
		wait(function ()
			stap(v)
			curTarget = findOne('�����ɾ�����')
			if curTarget and v:find(curTarget[1].text) then return 1 end
		end)
		-- �������ռǱȽ�����
		if v == '�����������ռ�' then
			local targ = {'����ÿ�ճɾ�', '����ÿ�ܳɾ�'}
			local key = {{'ÿ��', '��'}, {'ÿ��', '��'}}
			for i,v in pairs(targ) do
				if findOne(v) then
					-- �л��� ÿ��/ÿ�ܵ���
					wait(function ()
						stap(v)
						if findOne('����ÿ��ÿ�ܵ���', {keyword = key[i]}) then return 1 end
					end)
					untilTap('����ÿ��ÿ��С����', {rg = {415,141,946,185}, sim = .98})
					wait(function ()
						stap({574,40})
						if findOne('���������ܷ��·���') then return 1 end
					end)
				end
			end
		else
			-- wait(function ()
			-- 	findTap('�����ɾ���ȡ��ɫ')
			-- 	if findOne('�����ɾ�ǰ����ɫ') then log(11) return 1 end
			-- 	stap({574,40})
			-- end)
			if findOne('ȫ����ȡ���') then
				longDisappearTap('ȫ����ȡ���', nil, {863,102}, 1.5, 15)
			end
		end
	end
end

path.������� = function ()
	if findOne('�����������') then untilTap('�����������') else log('�޳������') end
end

-- ���ʷ��͹���λ�ò�һ�����������ʼ���ʽ����һ���ƺ�
-- todo
path.��ȡ�ʼ� = function ()
	if not findOne({'�����ʼ�', '�����ʼ�2'}) then log('���ʼ�') return 1 end
	wait(function ()
		stap(point.�ʼ�)
				ssleep(1)
			if not findOne('������ҳRank') then return 1 end
	end)
	untilAppear({'�����ʼ�ҳ��', '���ʷ��ʼ�'})
	wait(function ()
		stap({911,87})
		if findTap('�����ʼ���ȡȷ������') then return 1 end
	end)
	wait(function ()
		stap({563,85})
		if findOne('�����ʼ�ҳ��') then return 1 end
	end)
	-- �����޷���ȫ����ȡ��
	-- ���ܻ���װ����Ҫ����
	wait(function ()
		if not findTap('�����ʼ���ȡ�̵�') then return 1 end
		local tmp, target = untilAppear({'�����ʼ�����', '�����ʼ���ȡ����', '�����ʼ���ý���Tip',
		'�����ʼ�ҳ��', '�����ʼ���ȡӢ��ȷ��', '���������ռ䲻��'})
		if target and (target ~= '�����ʼ�ҳ��' and target ~= '���������ռ䲻��')  then untilTap(target) end
		if target and target == '���������ռ䲻��'  then
			path.��������(function () path.��ת('�����ʼ�ҳ��') end)
		end
		wait(function ()
			stap({563,85})
			findTap('�����ʼ���ȡӢ��ȷ��')
			if findOne('�����ʼ�ҳ��') then ssleep(.5) return 1 end
		end)
	end, 1, 5 * 60, nil, true)
end

path.ÿ�յ��� = function ()
	if not findOne({'�����ٻ�С���'}) then log('�����ٻ�') return 1 end
	wait(function ()
		stap(point.�ٻ�)
				ssleep(1)
			if not findOne('������ҳRank') then return 1 end
	end)
	-- Ѱ����Լ�ٻ�
	local pos, target
	wait(function ()
		sswipe({1141,588}, {1141,100})
		ssleep(1)
		pos = findOne('�����ٻ�����', {keyword = {'ʥԼ�ٻ�', '��Լ�ٻ�', '��Լ', 'ʥԼ'}})
		if pos then return 1 end
	end)
	wait(function ()
		stap({pos[1].l, pos[1].t})
		if findOne('����10���ٻ�') then ssleep(1) return 1 end
	end)
	if findTap('�������1���ٻ�') then untilTap('�����ٻ�ȷ��') end
	wait(function ()
		stap({156,659})
		if findOne('����10���ٻ�') then return 1 end
	end)
end

path.ʥ���ղ� = function ()
	if not findOne({'����ʥ��С���'}) then log('�����ղ�') return 1 end
	wait(function ()
		stap(point.ʥ��)
			ssleep(1)
		if not findOne('������ҳRank') then return 1 end
	end)
	path.ʥ������������ȡ()
	path.ʥ����֮ɭ��ȡ()
end

path.ʥ������������ȡ = function ()
	untilAppear('����ʥ����ҳ')
	log('ŷ�ձ�˹֮�Ĵ���')
	wait(function ()
		if findTap('����ŷ�ձ�˹֮��') then
			return 1
		end
	end, .1, 1)
	wait(function ()
		stap({649,58})
		if findOne('����ʥ����ҳ') then ssleep(.5) return 1 end
	end)
end

path.ʥ����֮ɭ��ȡ = function ()
	log('����֮ɭ����')
	local target = {'����ʥ����쵰', 
									'����ʥ����֮Ȫ', 
									'����ʥ����ֲ��', 
									'����ʥ����ֲ���ջ�'}
	if findTap('����ʥ����֮ɭС���') then
		-- untilAppear('��������״̬')
		wait(function ()
			stap({104,100})
			if findOne('����ʥ����쳲Ѩ') then return 1 end
		end)
		for i,v in pairs(target) do
			if wait(function () if findTap(v) then return 1 end end, 0, .5) then
				wait(function ()
					stap({104,100})
					if findOne('����ʥ����쳲Ѩ') then return 1 end
				end)
			end
		end
	end
	path.ʥ����ҳ()
end

local number = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
-- todo
path.ʥ��ָ���ܲ� = function ()
	log('ָ���ܲ�����')
	local target = '�ַ�'
	if findTap('����ʥ��ָ���ܲ�С���') then
		untilAppear('��������״̬')
		wait(function ()
			stap(point.ʥ��ָ���ܲ�����[target])
			if findOne('����ʥ��ָ���ܲ�����ѡ��', {keyword = {target}}) then return 1 end
		end)
		local dispatchLevel = findOne('������ǲ����ȼ�')
		local dispatchLevelSort = {'12', '8', '6', '4', '2', '1', '30'}
		if not dispatchLevel then log('����ǲ') return 1 end
		if #dispatchLevel > 1 then
			-- ���˷���ǲ�ȼ�
			dispatchLevel = table.filter(dispatchLevel,
			function (v) if v.text:includes({'����ʱ��', 'Сʱ', '��', '��'}) and
			findOne('������ǲִ��', {rg = {890, v.t, 980, v.b + 75}}) then return 1 end end)
			-- �������õȼ���ѯ������ǲlevel
			for i,v in pairs(dispatchLevelSort) do
				local result = table.findv(dispatchLevel, function (val) if val.text:includes({v}) then return 1 end end)
				if result then dispatchLevel = result break end
			end
		end
		untilTap('������ǲִ��', {rg = {890, dispatchLevel.t, 980, dispatchLevel.b + 75}})
		untilAppear('������ǲִ������')
		local needLevel = getArenaPoints(untilAppear('������ǲ����ȼ�', {keyword = {'Lw', 'L', 'v', 'w'}})[1].text)
		-- �Լ�����Ӣ������
	end
end

path.ʥ����ҳ = function ()
	wait(function ()
		if findOne('����ʥ����ҳ') then ssleep(1) return 1 end
		stap({31,32})
		ssleep(2)
	end)
end

path.�����̵� = function ()
	log('��������&����')
	wait(function ()
		stap(point.�̵�)
		ssleep(1)
		return not findOne('������ҳRank')
	end)
	untilAppear('����һ���̵�')
	
	local target = wait(function ()
		sswipe( {1178,692}, {1178,200} )
		ssleep(1)
		return findOne('�����̵�', {rg = {1038,62,1279,716}})
	end)

	wait(function ()
		stap({target[1], target[2] + 40})
		ssleep(1)
		return findOne('5������', {keyword = {'5������', '����', '5��'}})
	end)

	local goods = {'�ж�������', '���Ĺ���'}
	for i=1,#goods do
		if findTap(goods[i]) and untilTap('�����̵깺��') then
			longAppearAndTap('����һ���̵�', nil, {447,47}, 1.5)
		end
	end
end

path.ս��ѡ��ҳ = function ()

	wait(function ()
		stap(point.ս��)
			ssleep(1)
			if not findOne('������ҳRank') then return 1 end
	end)

	wait(function ()
		if findOne('����2���ʺ�') then
			if findOne('ս���·���������') then
				return 1
			end
			-- ��� <-
			stap({378,663})
		end
	end, 1)

	wait(function ()
		stap({232,525})
		if not findOne('�����Թ���ҳ', {sim = 1}) then ssleep(1) return 1 end
	end)
end

-- ˢͼ
path.ˢͼ���� = function ()
	-- ͼ����
	log('����ˢͼ')
	-- �ַ�
	local stageAll = ui_option.ս������
	local currentStage = sgetNumberConfig('current_stage', 1)
	for i,v in pairs(stageAll) do
		if current_task[v] and i >= currentStage then
			if v:includes({'�ַ�', '�Թ�', '�����̳', '��Ԩ'}) then
				path.ս��ѡ��ҳ()
				wait(function ()
					stap(point.ս��ģʽλ��[v])
					if findOne('����ս������', {keyword = cutStringGetBinWord(v)}) then return 1 end
				end)
			end
			if path[v]() ~= 0 then
				slog(v..'���')
			else
				slog(v..'δ���')
			end
			-- ����ˢͼ����
			setNumberConfig("fight_count", 0)
			sgetNumberConfig('current_stage', i)
			path.��Ϸ��ҳ()
		end
	end
end

path.ս����ͼ = function (levelTarget)
		-- ȷ�����������ϲ�
	wait(function ()
		sswipe({835,100}, {835,3000})
		ssleep(1)
		return findOne('�ؿ�����')
	end, 0)
	-- ��������
	local newTextVal
	-- ��ֵ�ظ�����
	local newTextValReCount = 0
	local curTextVal
	wait(function ()
		wait(function ()
			curTextVal = findOne('����ս������')
			if curTextVal then curTextVal = curTextVal[1].text return 1 end
		end, .05, .3)
		if curTextVal and curTextVal:find(levelTarget) then return 1 end
		if not newTextVal then
			newTextVal = curTextVal
			newTextValReCount = newTextValReCount + 1
		else
			if newTextVal == curTextVal then
				newTextValReCount = newTextValReCount + 1
			else
				newTextVal = curTextVal
				newTextValReCount = 0
			end
			if newTextValReCount == 3 then
				sswipe({835,100}, {835,3000})
				ssleep(1)
				newTextVal = nil
				newTextValReCount = 0
			end
		end
		p = findOne('�����Ȧ')
		if p then p = {p[1], p[2] + 50} stap(p) ssleep(1) end
	end, 0, 5 * 60)

	-- 0 ��ʾ��ͼ��δ���
	local selectGroup
	if not wait(function ()
		return wait(function ()
			if findTapOnce('������ѡ�����', {rg = {988,600,1278,717}}) then
				return wait(function ()
					if not findOne('������ѡ�����', {rg = {988,600,1278,717}}) then return 1 end
				end, .3, 5)
			end
		end)
	end, .5, 5) then
		log('δ�����ؿ�')
		slog('δ�����ؿ�')
		return 0
	end
end

path.ս����ͼ1 = function (typeTarget, levelTarget, fightCount, isActivity)
	-- local p
	-- local key = {'�׶�', '��̳', '����', '�ַ�'}
	-- �ؿ�
	if typeTarget then
		for i=1,3 do
			if wait(function ()
				if findTap(typeTarget, {rg = point.����ս����������, sim = .9}) then return 1 end
				swipeEndStop({834,686}, {834,300}, .3)
				ssleep(1)
			end, 1, 5) then
				break
			else
				sswipe({835,300}, {835,2000})
				ssleep(1)
			end
			if i == 3 then slog('�ؿ�����δ������ʱ��') return 0 end
		end
	end
	untilAppear('������ѡ�����', {rg = {988,600,1278,717}})

	if path.ս����ͼ(levelTarget) == 0 then
		return 0
	end

	return path.ͨ��ˢͼģʽ1(fightCount, isActivity, levelTarget)
end

-- ��ͼģʽ1
-- �ַ� �����̳
-- 834,686 834,147
-- fightCount: 10
path.ͨ��ˢͼģʽ1 = function (fightCount, isActivity, levelTarget)
	global_stage_count = fightCount
	local rightBottomRegion = isActivity and '�������½ǻ' or '�������½�'
	untilAppear(rightBottomRegion, {keyword = {'ս����ʼ'}})	ssleep(.5)
	-- ��������еĻ�,�ʹ���
	local isAgent = path.�йܴ���(isActivity)
	local pos, noAct
	if wait(function ()
		pos, noAct = findOne({'���������ռ䲻��', '�����ж�������', rightBottomRegion}, {keyword = {'ս����ʼ', 'ѡ�����'}})
		if noAct == '�����ж�������' then
			slog('�ж�������')
			log('�ж�������!')
			if path.��������() == 0 then return 0 end
		end
		if noAct == '���������ռ䲻��' then return 1 end
		if noAct == rightBottomRegion then stap({pos[1].l, pos[1].t}) end
		if findOne({'����������', '����һ����'}) then return 1 end
	end) == 0  then
		return 0
	end
	local tmp, noAction
	wait(function ()
		tmp, noAction = findOne({'���������ռ䲻��', '����������', '����һ����'})
		if noAction then return 1 end
	end)

	local staticTarget = {'���������ռ䲻��', '����������', '�����ж�������', '����һ����'}

	local currentCount = sgetNumberConfig('fight_count', 1)
	while currentCount <= fightCount do
		if noAction ~= '���������ռ䲻��' then
			path.ս������(1, isAgent, currentCount, isActivity)
			log('��ɴ���: '..currentCount)
		end
		local retCode = wait(function ()
			-- ƣ������
			wait(function ()
				tmp, noAction = findOne(staticTarget)
				if noAction then return 1 end
			end)
			-- �ж���
			if noAction == '�����ж�������' then
				slog('�ж�������')
				log('�ж�������!')
				if path.��������() == 0 then return 0 end
				-- ��Ҫ�����ͼ
				wait(function ()
					if findOne(staticTarget) then return 1 end
					if findOne(rightBottomRegion, {keyword = 'ս����ʼ'}) then
						stap({1150,659})
					end
				end)
			end
			-- �ж���������
			if noAction == '���������ռ䲻��' then
				-- �Ƿ��Ǻ�ǣ���ǱȽ�����, ���������ᵽ׼��ս��ҳ��
				path.��������(function ()
						wait(function ()
							stap({487,18})
							return longAppear('�������ؼ�ͷ')
						end)
						wait(function ()
							if longAppear({'δ���صĹ���', '�������', '�����Ȧ'}) then
								return 1
							end
							stap({60,29})
						end)
						if levelTarget == '���' then
							-- ��һ�β��ᵽδ���صĹ���
							local rvb, res = untilAppear({'δ���صĹ���', '�������'})
							if res == 'δ���صĹ���' then
								untilAppear('���׼��ս��')
								wait(function ()
									if findTapOnce('���׼��ս��') then
										return wait(function ()
											return not findOne('���׼��ս��')
										end, 1, 5)
									end
								end)
							end
						else
							local rvb, res = untilAppear({'�����Ȧ', '�������'})
							if res == '�����Ȧ' then
								path.ս����ͼ(levelTarget)
							end
						end
				end)
				-- �ٴε�������ܻ�����ֱ�������
				-- һ������: return 1
				-- �ж��������ռ䲻��: ֱ��return 0
				local pos
				local resultCode = wait(function ()
					pos = findOne(rightBottomRegion, {keyword = {'ս����ʼ', '׼��ս��', 'ѡ�����'}})
					if pos then stap({pos[1].l, pos[1].t}) ssleep(1) end
					tmp, noAction = findOne(staticTarget)
					if noAction == '����������' or noAction == '����һ����' then return 1 end
					if noAction == '�����ж�������' or noAction == '���������ռ䲻��' then return 0 end
				end)
				if resultCode == 1 then return 1 end
				if resultCode == 0 then return end
			end
			return 1
		end, 1, 5 * 60)
		if retCode == 0 then
			return 0
		end
		if retCode == 1 then
			currentCount = currentCount + 1
			setNumberConfig("fight_count", currentCount)
		end
	end
end

path.�������� = function ()
	local energyType = current_task.�����ж�������
	local targetRg = {352,237,935,456}
	local pos
	if energyType == 2 then slog('�������ж���') return 0 end
	if energyType == 0 then
		if not wait(function ()
			pos = findOne('�����ж���Ҷ��', {rg = targetRg})
			if pos then stap(pos) return 1 end
		end, .1, 3) then
			slog('δ�ܲ����ж���')
			return 0
		end
	end
	if energyType == 1 then
		-- ����Ҷ��
		-- ������Ҷ��
		if not wait(function ()
			pos = findOne({'�����ж���Ҷ��', '�����ж���שʯ'}, {rg = targetRg})
			if pos then stap(pos) return 1 end
		end) then
			slog('δ�ܲ����ж���')
			return 0
		end
	end
	-- ���ȷ��
	-- ������bug, ���Ҷ�Ӻ�שʯ��û����
	-- untilTap('��������������Ʊ')
	if not wait(function ()
		if findTap('��������������Ʊ') then return 1 end
	end, .1, 5) then
		slog('�����ж���ʧ��')
		return 0
	end
	return 1
end

path.�йܴ��� = function (isActivity)
	log('�йܴ���')
	local greenPos
	local petAgent = current_task.�����ظ�ս��
	-- ���λ�ÿ��ܲ�һ��
	local trg = isActivity or {563,528,685,584}
	if not wait(function ()
		greenPos = findOne('�����Ƿ���Զ��һ�', {rg = trg, sim = .8})
		if greenPos then return 1 end
	end, .1, 1.5) then
		log('δ�ҵ��й�')
		slog('δ�ҵ��й�')
	else
		local s
		wait(function ()
			s = findOne('�����ظ�ս����ɫ', {rg = trg, sim = .9})
			if petAgent and s then 
				return 1
			end
			if not petAgent and not s then
				return 1
			end
			stap({greenPos[1] - 55, greenPos[2]})
		end)
	end
	return petAgent
end

-- ��ͼģʽ2
path.ͨ��ˢͼģʽ2 = function ()
	print('todo')
end

-- ��ͼ
path.�ַ� = function ()
	local type = '����'..getUIRealValue('�ַ��ؿ�����', '�ַ�����')
	local level = getUIRealValue('�ַ�����', '�ַ�����')
	local fc = current_task.�ַ�����
	return path.ս����ͼ1(type, level, fc)
end

path.�����̳ = function ()
	local type = '����'..getUIRealValue('�����̳�ؿ�����', '�����̳����')..'����'
	local level = getUIRealValue('�����̳����', '�����̳����')
	local fc = current_task.�����̳����
	return path.ս����ͼ1(type, level, fc)
end

path.������Ԩ = function ()
	wait(function ()
		stap(point.ս��)
				ssleep(1)
			if not findOne('������ҳRank') then return 1 end
	end)
	path.ս��ѡ��ҳ()
	wait(function ()
		stap(point.ս��ģʽλ��['��Ԩ'])
		if findOne('����ս������', {keyword = cutStringGetBinWord('��Ԩ')}) then return 1 end
	end)
	if findTap('������Ԩ����') then
		untilTap('������Ԩ����ȷ��')
	end
end

path.���ﱳ������ = function ()
	wait(function ()
		stap({1160,668})
		if findOne('���������Զ�����') then
			return 1
		end
	end)
	
	wait(function ()
		stap('���������Զ�����')
		ssleep(1)
		if findOne('���������Զ����Ŀ��') then return 1 end
	end)
	
	path.���˱���ѡ��(ui_option.���Ｖ��, '��������')
	-- ��������
	wait(function ()
		if findOne('�����������ص����ͳ���') then return 1 end
		stap('�����������ص����ͳ���')
	end)
	
	wait(function ()
		stap({995,657})
		if not findOne('���������Զ����Ŀ��') then
			return 1
		end
	end)
	
	-- ����û������
	if not wait(function ()
		if findTap('�����ͷų���') then
			return 1
		end
	end, .5, 5) then
		return
	end
	wait(function ()
		if findTap('�����ʼ���ȡȷ������') then
			return 1
		end
	end, .5, 5)
end

path.����װ������ = function ()
	local sellAndExtractPriority = current_task['������ȡ���ȶ�'] or 0
	wait(function ()
		stap({341,88})
		return findOne('����������ҳ')
	end)
	wait(function ()
		if findOne('��������ȫ��') then
			return 1
		end
		stap({186,164})
	end, 1)
	wait(function ()
		if findOne('��������װ���Զ�ѡ��') then
			return 1
		end
		stap({1081,157})
	end)
	wait(function ()
		if not findOne('��������װ���Զ�ѡ��') then
			return 1
		end
		stap('��������װ���Զ�ѡ��')
	end)
	path.���˱���ѡ��(ui_option.װ������, '����')
	path.���˱���ѡ��(ui_option.װ���ȼ�, '����')
	path.���˱���ѡ��(ui_option.װ��ǿ���ȼ�, '����')
	
	local weaponType = {
		'185|231|00CB64',
		'185|284|00CB64',
		'185|336|00CB64',
		'185|389|00CB64',
		'185|444|00CB64',
		'186|496|00CB64',
	}
	
	for i,v in pairs(weaponType) do
		local pos = string.split(v, '|')
		pos = {tonumber(pos[1]), tonumber(pos[2])}
		wait(function ()
			if findOne(v) then return 1 end
			stap(pos)
		end, 1)
	end
	
	wait(function ()
		if findOne('��������װ���Զ�ѡ��') then
			return 1
		end
		stap({334,90})
	end)
	
	-- ����û������
	-- ���ȶ��ж�
	-- 0 �������ȣ�1 ��ȡ����
	if sellAndExtractPriority == 0 then
			return path.װ����������()
	elseif sellAndExtractPriority == 1 then
		if findOne('���ʷ���ȡ����') then
			return path.װ����ȡ����()
		else
			return path.װ����������()
		end
	end

end

path.װ���������� = function ()
	if not wait(function ()
		if findTap('����װ������') then
			return 1
		end
	end, .5, 5) then
		return
	end
	wait(function ()
		if findTap('��������ȷ��') then
			return 1
		end
	end, .5, 5)
end

path.װ����ȡ���� = function ()
	if not wait(function ()
		if findTap('���ʷ���ȡ����') then
			return 1
		end
	end, .5, 5) then
		return
	end
	wait(function ()
		if findTap('���ʷ���ȡ����ȷ��') then
			return 1
		end
	end, .5, 5)
end

path.����Ӣ�۱��� = function (count, filterFunc)
	count = count or 1

	wait(function ()
		stap({1019,666})
		if findOne('��������Ӣ��') then return 1 end
	end)
	
	wait(function ()
		stap({1081,89})
		ssleep(1)
		if findOne('715|210|44C8FD,715|260|45CBFE,715|312|44C8FD') then
			return 1
		end
	end)
	-- ���˵ȼ�
	if not filterFunc then
		path.���˱���ѡ��(ui_option.Ӣ�۵ȼ�, '����Ӣ��')
	else
		filterFunc()
	end
	
	-- ��������
	local specialSetting = {
		'883|605|00CB64', -- �����ղ�Ӣ��
		'883|657|00CB64', -- �������ܶ�10
		'587|657|00CB64', -- ����MAX�ȼ�
	}
	for i,v in pairs(specialSetting) do
		local pos = string.split(v, '|')
		pos = {tonumber(pos[1]), tonumber(pos[2])}
		wait(function ()
			if findOne(v) then return 1 end
			stap(pos)
		end, 1)
	end
	
	for i=1,count do
		wait(function ()
			stap({548,34})
			return findOne('��������Ӣ��') and findOne('109|656|24A5FD,113|650|50D7FE') -- ���½�Ӳ��
		end)
		
		if wait(function ()
			if longDisappearMomentTap('1052|242|7E411F', nil, nil, 2) then
				-- δ��������
				wait(function ()
					if findTap('��������Ӣ��') then
						return 1
					end
				end, .3, 5)
				wait(function ()
					if findTap('����Ӣ�۴���ȷ��') then
						return 1
					end
				end, .3, 5)			
				return 0
			end
			if findOne('714|543|41C2FC') then
				return 1
			end
			stap({1121,273})
		end) == 0 then
			log('��Ӣ�۴���')
			slog('��Ӣ�۴���')
			return 
		end
		
		wait(function ()
			stap({548,34})
			if findOne('��������Ӣ��') then return 1 end
		end)
		
		-- ����û������
		if not wait(function ()
			if findTap('��������Ӣ��') then
				return 1
			end
		end, .3, 5) then
			return
		end
		wait(function ()
			if findTap('����Ӣ�۴���ȷ��') then
				return 1
			end
		end, .3, 5)
	end
end

path.������������ = function ()
	untilAppear('����������ҳ')
	wait(function ()
		if findOne('��������ȫ��') then
			return 1
		end
		stap({186,164})
	end, 1)
	wait(function ()
		if findOne('��������װ���Զ�ѡ��') then
			return 1
		end
		stap({1081,157})
	end)
	wait(function ()
		if not findOne('��������װ���Զ�ѡ��') then
			return 1
		end
		stap('��������װ���Զ�ѡ��')
	end)
	path.���˱���ѡ��(ui_option.�����Ǽ�, '��������')
	path.���˱���ѡ��(ui_option.����ǿ��, '��������ǿ��')
	wait(function ()
		if findOne('��������װ���Զ�ѡ��') then
			return 1
		end
		stap({332,86})
	end)
	-- ����û������
	if not wait(function ()
		if findTap('������������') then
			return 1
		end
	end, .5, 5) then
		return
	end
	wait(function ()
		return findTap('��������ȷ��')
	end, .5, 5)
end
-- ���˵ȼ���������
-- level������table
-- target: Ŀ��ǰ׺
path.���˱���ѡ�� = function (level, target)
	for i,v in pairs(level) do
		local target = target..v
		if current_task[v] then
			wait(function ()
				if findOne(target) then return 1 end
				stap(target)
			end)
		else
			wait(function ()
				if not findOne(target) then
					return 1
				end
				stap(target)
			end)
		end
	end
end

-- target: ��Ҫѡ���
path.���˱����Զ���ѡ�� = function (level, targetName, target)
	if type(target) ~= 'table' then target = {target} end
	for i,v in pairs(level) do
		local targetPos = targetName..v
		if targetPos:includes(target) then
			wait(function ()
				if findOne(targetPos) then return 1 end
				stap(targetPos)
			end)
		else
			wait(function ()
				if not findOne(targetPos) then
					return 1
				end
				stap(targetPos)
			end)
		end
	end
end

path.��ת = function (target, config)
	wait(function ()
		if not longAppearMomentDisAppear(target, config, nil, 1) then return 1 end
		back()
	end, 2, 5 * 60)
end

-- backFunc: ���غ���
path.�������� = function (backFunc)
	-- ʶ�𱳰�����
	slog('�������ռ�')
	log('�������ռ�!')
	local bagSpaceType
	local bagKey = {'Ӣ��', 'װ��', '����'}
	wait(function ()
		bagSpaceType = findOne('����������', {keyword = bagKey})
		if bagSpaceType then
			bagSpaceType = bagSpaceType[1].text
			return 1
		end
	end)
	-- ���뱳��
	untilTap('���������ռ䲻��')
	-- ������
	-- print(bagSpaceType)
	if bagSpaceType:includes({'Ӣ��'}) then
		path.����Ӣ�۱���()
	elseif bagSpaceType:includes({'װ��'}) then
		path.����װ������()
	elseif bagSpaceType:includes({'����'}) then
		path.������������()
	end
	backFunc()
end

path.��3�ǹ��� = function ()
	path.��Ϸ��ҳ()
	-- �� + ���� ?
	setNumberConfig("is_refresh_book_tag", 2)
	local upgradeCount = current_task.��3�ǹ�������
	local type = current_task.��3�ǹ�������
	if type == 0 or type == 2 then
		path.������_3(upgradeCount)
	end
	if type == 1 or type == 2 then
		path.��Ϸ��ҳ()
		if not path.���Ҳ���('�Ҳ���Ӣ��') then
			return
		end
		-- ֱ��������3�ǵ�
		path.����Ӣ�۱���(1352955539, function ()
			path.���˱����Զ���ѡ��(ui_option.Ӣ�۵ȼ�, '����Ӣ��', {3})
		end)
	end
end

path.������_3 = function (upgradeCount)
	if not path.���Ҳ���('�Ҳ���Ӣ��') then
		return
	end
	wait(function ()
		if findOne('714|209|45CBFE,716|261|44C8FD,715|312|44C8FD') then
			return 1
		end
		stap({1085,89})
	end)
	-- ���˵ȼ�
	path.���˱����Զ���ѡ��(ui_option.Ӣ�۵ȼ�, '����Ӣ��', {2})
	
	-- ��������
	local specialSetting = {
		'883|605|00CB64', -- �����ղ�Ӣ��
		'883|657|00CB64', -- �������ܶ�10
		-- '587|657|00CB64', -- ����MAX�ȼ�
		'590|604|201F1A' -- �ر���С����
	}

	for i,v in pairs(specialSetting) do
		local pos = string.split(v, '|')
		pos = {tonumber(pos[1]), tonumber(pos[2])}
		wait(function ()
			if findOne(v) then return 1 end
			stap(pos)
		end, 1)
	end

	-- ���ѡ����1
	wait(function ()
		if not findOne('���ѡ����1') then
			stap('���ѡ����1')
		else
			return 1
		end
	end)

	wait(function ()
		if findOne('����Ӣ�۾���') then
			return 1
		end
		stap({485,31})
	end)

	-- ���и���Դ����
	local target = {'����Ӣ��������첻��', 
									'���������̵깺����Դ����', 
									'����Ӣ��������������', 
								  '����Ӣ������2', 
									'����Ӣ������3', 
									'����Ӣ������3��',
									'��������ɹ�'}
	local tkey = {'��Դ����', '����'}
	local curIdx = sgetNumberConfig('upgrade_3x_hero', 0)
	for i=1,upgradeCount do
		if i > curIdx then
			if not wait(function ()
				if not findOne('����Ӣ������3��', {rg = {88,65,604,175}}) then
					return 1
				end
				stap({1063,243})
			end, .1, 5) then
				log('��2��Ӣ��')
				slog('��2��Ӣ��')
				return
			end
			untilTap({'����Ӣ������1', '��췵��'})
			local t, v
			if wait(function ()
				t, v = findOne(target, {rg = {88,65,604,175}, keyword = tkey})
				if v == '����Ӣ������3��' then
					log('����2�Ǹ���: '..i..'/'..upgradeCount)
					return 1
				end
				if  v == '����Ӣ��������첻��' or 
						v == '���������̵깺����Դ����' or 
						v == '����Ӣ��������������' then
						-- log(v)
						log('��Դ����')
						slog('��Դ����')
						return 0
				end
				if v == '��������ɹ�' then
					stap({992,664})
				end
				-- ������� > �Զ�����
				if findOne('����Զ�����') and not findTapOnce('�������') then
					stap({997,664}) -- �Զ�������ť
				end
				-- �������
				stap({531,23})
				stap(t)
			end) == 0 then
				return
			end
			setNumberConfig("upgrade_3x_hero", i)
		end
	end
end

path.���Ҳ��� = function (pos)
	if not findOne('������ҳRank') then
		log('δ����ҳ')
		return 
	end
	wait(function ()
		if findOne('�����Ҳ�����') then
			return 1
		end
		stap({1241,32})
		ssleep(1)
	end)
	wait(function ()
		if not findOne('�����Ҳ�����') then
			return 1
		end
		stap(point[pos])
	end)
	return 1
end

path.������� = function ()
	path.��Ϸ��ҳ()
	wait(function ()
		stap({247,214})
		return findOne('327|239|5B80C4,316|240|BF898F,335|238|4CEAFF')
	end)
	-- ��ʼ����
	-- ������ʾ���
	local noTipTap = false
	wait(function ()
		if findOne('612|638|F4A300,680|637|FBA900') then
			log('��Ҷ������')
			slog('��Ҷ������')
			return 1
		end
		if not noTipTap and findTap('������첻����ʾ') then
			noTipTap = true
		end
		stap({903,280})
	end, .5, nil, true)
end

path.��Ϸ���� = function ()
	wait(function ()
		stap(point.�)
		ssleep(1)
		return not findOne('������ҳRank')
	end)
	wait(function ()
	end)
	-- ������� + ����
	-- ǩ��
end

path.��� = function ()
	wait(function ()
		stap(point.֧�߹���)
		ssleep(1)
		return not findOne('������ҳRank')
	end)

	wait(function ()
		stap({1243,415})
		stap({350,28})
		return findTap('���ð��')
	end)

	-- wait(function () return findTapOnce('���׼��ս��') end)
	
	wait(function ()
		if findTapOnce('���׼��ս��') then
			return wait(function ()
				return not findOne('���׼��ս��')
			end, 1, 5)
		end
	end)


	path.������������()

	local fightCount = current_task.��Ǵ���
	return path.ͨ��ˢͼģʽ1(fightCount, nil, '���')
end

path.�����ظ�ˢ = function ()
	wait(function ()
		stap(point.ð��)
		ssleep(1)
		return not findOne('������ҳRank')
	end)

	wait(function ()
		if findTapOnce('���׼��ս��') then
			return wait(function ()
				return not findOne('���׼��ս��')
			end, 1, 5)
		end
	end)

	path.������������()

	local fightCount = current_task.�����ظ�ˢ����
	return path.ͨ��ˢͼģʽ1(fightCount, nil, '���')
end

path.� = function ()
	local fc = current_task.�����
	wait(function ()
		stap(point.֧�߹���)
		ssleep(1)
		return not findOne('������ҳRank')
	end)
	local e, w
	local whichAct = current_task['�ָ��'] or 1
	wait(function ()
		stap({61,187})
		-- ����
		if whichAct == 0 then
			stap({1059,285})
		elseif whichAct == 1 then
			stap({998,468})
		end

		e, w = findOne({'�ð��', '���ҳ'}, {keyword = '��Ļ'})
		return w
	end)
	wait(function ()
		stap({1166,661})
		return findOne('���׼��ս��')
	end)
	wait(function ()
		if findTapOnce('���׼��ս��') then
			return wait(function ()
				return not findOne('���׼��ս��')
			end, 1, 5)
		end
	end)
	-- �ж�����һ�ֻ
	if w == '�ð��' then
		log('�-Ĭ�Ϲؿ�')
		local tmpv, curPassType = untilAppear({'ѡ���Ѷȳ���', '����Ӣ�۶ӳ�'})
		if curPassType == '����Ӣ�۶ӳ�' then
			path.������������()
		elseif curPassType == 'ѡ���Ѷȳ���' then
			path.������������()
		end
		return path.ͨ��ˢͼģʽ1(fc, nil, '���')
	elseif w == '���ҳ' then
		log('�-��ѡ�ؿ�')
		wait(function ()
			stap({994,657})
			return findOne('�������½�', {keyword = 'ս����ʼ'})
		end)
		local level = getUIRealValue('�����', '�����')
		return path.ս����ͼ1(nil, level, fc, {175,613,357,714})
	end
end

path.�����ǩ = function ()
	current_task['���´���'] = 0
	path.ˢ��ǩ(0, true)
end

path.������������ = function ()
	wait(function ()
		if findOne('������ѡ�����') and longAppear('������ѡ�����') then 
			findTapOnce('������ѡ�����')
			return wait(function ()
				return not findOne('������ѡ�����')
			end, 1, 5)
		end
	end)
end