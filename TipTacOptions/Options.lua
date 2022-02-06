local cfg = TipTac_Config;
local modName = "TipTac";
local ignoreConfigUpdate;

-- Options
local activePage = 1;
local frames = {};
local options = {
	-- General
	{
		[0] = "Общие",
		{ type = "Check", var = "showUnitTip", label = "Включить подсказки TipTac", tip = "Изменить внешний вид подсказок. Многие параметры в TipTac работают только при включенном этом параметре.", y = 8 },
		{ type = "Check", var = "showStatus", label = "Показать статус DC, AFK и DND", tip = "Показать статус <DC-не в сети>, <AFK-отсутствует> и <DND-не беспокоить> после имени игрока." },
		{ type = "Check", var = "showGuildRank", label = "Показать звание игрока в гильдии", tip = "В дополнение к названию гильдии, если эта опция включена, вы также увидите звание игрока в гильдии." },
		{ type = "Check", var = "showTargetedBy", label = "Показать, кто нацелился на вашу цель", tip = "Находясь в рейде или группе, подсказка покажет, кто из вашей группы нацелился на вашу цель.", y = 16 },
		{ type = "DropDown", var = "nameType", label = "Имя", list = { ["Только имя"] = "normal", ["Имя и звание"] = "title", ["Использовать исходник"] = "original" } },
		{ type = "DropDown", var = "showRealm", label = "Игровой мир", list = { ["Показать"] = "show", ["Не показывать"] = "none", ["Показать (*) вместо"] = "asterisk" } },
		{ type = "DropDown", var = "showTarget", label = "Показать цель", list = { ["Не показывать цель"] = "none", ["Первая строка"] = "first", ["Вторая строка"] = "second", ["Последняя строка"] = "last" }, y = 16 },
		{ type = "Text", var = "targetYouText", label = "Свой текст" },
	},
	-- Special
	{
		[0] = "Спец.",
		{ type = "Slider", var = "gttScale", label = "Масштаб", min = 0.2, max = 4, step = 0.05 },
		{ type = "Slider", var = "updateFreq", label = "Частота обновления", min = 0, max = 5, step = 0.05 },
 	},
	-- Colors
	{
		[0] = "Цвета",
		{ type = "Color", subType = 2, var = "colSameGuild", label = "Цвет названия гильдии", tip = "Чтобы лучше узнавать согильдийцев, вы можете настроить цвет для названия вашей гильдии." },
		{ type = "Color", subType = 2, var = "colRace", label = "Цвет расы и типа существа", tip = "Цвет текста для расы или типа существа" },
		{ type = "Color", subType = 2, var = "colLevel", label = "Цвет нейтральных существ", tip = "Цвет текста для нейтральных существ.", y = 12 },
		{ type = "Check", var = "colorNameByClass", label = "Окрасить имена игроков по цвету класса", tip = "Если эта опция включена, имена игроков окрашиваются в цвет их класса, в противном случае они будут окрашиваться в зависимости от отношения к вам." },
		{ type = "Check", var = "classColoredBorder", label = "Окрасить границу подсказки по цвету класса", tip = "Для игроков, цвет границы подсказки будет окрашен, в соответствии с цветом их класса.", y = 12 },
		{ type = "Check", var = "itemQualityBorder", label = "Окрасить границу подсказки у предметов", tip = "Если этот параметр включен и подсказка показывает предмет, граница подсказки будет иметь цвет рамки предмета.\nВНИМАНИЕ! Должна быть включена опция «Специальные подсказки»." },
	},
	-- Reactions
	{
		[0] = "Репутация",
		{ type = "Check", var = "reactText", label = "Показать отношение объекта к вам", tip = "При включенной опции, отношение объекта будет отображаться в виде текста в последней строке.", y = 42 },
		{ type = "Color", subType = 2, var = "colReactText1", label = "Tapped" },
		{ type = "Color", subType = 2, var = "colReactText2", label = "Враждебность" },
		{ type = "Color", subType = 2, var = "colReactText3", label = "Неприязнь" },
		{ type = "Color", subType = 2, var = "colReactText4", label = "Равнодушие" },
		{ type = "Color", subType = 2, var = "colReactText5", label = "Дружественный NPC или PvP-игрок" },
		{ type = "Color", subType = 2, var = "colReactText6", label = "Дружественный игрок" },
		{ type = "Color", subType = 2, var = "colReactText7", label = "Мёрт" },
	},
	-- BG Color
	{
		[0] = "Цвет фона",
		{ type = "Check", var = "reactColoredBackdrop", label = "Цвет фона на основе отношения", tip = "Окрашивает фон подсказки выбранным цветом. Если этот параметр отключен, цвет фона будет выбран из раздела «Фон»." },
		{ type = "Check", var = "reactColoredBorder", label = "Цвет границы на основе отношения", tip = "То же, что и предыдущий вариант, только для границы.\nВНИМАНИЕ! Этот параметр переопределяет настройку «Окрасить границу подсказки по цвету класса».", y = 20 },
		{ type = "Color", var = "colReactBack1", label = "Tapped" },
		{ type = "Color", var = "colReactBack2", label = "Враждебность" },
		{ type = "Color", var = "colReactBack3", label = "Неприязнь" },
		{ type = "Color", var = "colReactBack4", label = "Равнодушие" },
		{ type = "Color", var = "colReactBack5", label = "Дружественный NPC или PvP-игрок" },
		{ type = "Color", var = "colReactBack6", label = "Дружественный игрок" },
		{ type = "Color", var = "colReactBack7", label = "Мёрт" },
	},
	-- Backdrop
	{
		[0] = "Фон",
		{ type = "DropDown", var = "tipBackdropBG", label = "Текстура фона", media = "background" },
		{ type = "DropDown", var = "tipBackdropEdge", label = "Текстура границы", media = "border", y = 8 },
		{ type = "Slider", var = "backdropEdgeSize", label = "Размер границы", min = 0, max = 64, step = 0.5 },
		{ type = "Slider", var = "backdropInsets", label = "Размер фоновой текстуры", min = -20, max = 20, step = 0.5, y = 18 },
		{ type = "Color", var = "tipColor", label = "Цвет фона подсказки" },
		{ type = "Color", var = "tipBorderColor", label = "Цвет границы подсказки", y = 10 },
		{ type = "Check", var = "gradientTip", label = "Показать градиент", tip = "Отобразить небольшую область градиента, в верхней части, чтобы добавить к нему 3D-эффект. Если у вас стоит аддон Skinner, отключите его, для избежания конфликтов.", y = 6 },
		{ type = "Color", var = "gradientColor", label = "Цвет градиента", tip = "Выберите основной цвет для градиента." },
	},
	-- Font
	{
		[0] = "Шрифт",
		{ type = "Check", var = "modifyFonts", label = "Изменить шрифт подсказок", tip = "Чтобы изменить шрифт, вы должны включить эту опцию в пользовательском интерфейсе.\nВНИМАНИЕ! Если у вас есть надстройка, например ClearFont, она может конфликтовать с этой опцией.", y = 12 },
		{ type = "DropDown", var = "fontFace", label = "Шрифт", media = "font" },
		{ type = "DropDown", var = "fontFlags", label = "Контур", list = TipTacDropDowns.FontFlags },
		{ type = "Slider", var = "fontSize", label = "Размер", min = 6, max = 29, step = 1 },
	},
	-- Classify
	{
		[0] = "Тип NPC",
		{ type = "Text", var = "classification_normal", label = "Обычный" },
		{ type = "Text", var = "classification_elite", label = "Элитный" },
		{ type = "Text", var = "classification_worldboss", label = "Босс" },
		{ type = "Text", var = "classification_rare", label = "Редкий" },
		{ type = "Text", var = "classification_rareelite", label = "Редкий элитный" },
	},
	-- Fading
	{
		[0] = "Затухание",
		{ type = "Check", var = "overrideFade", label = "Переопределить затухание", tip = "Переопределяет функцию постепенного исчезновения подсказок. Если вы видите проблемы с затуханием, отключите её.", y = 16 },
		{ type = "Slider", var = "preFadeTime", label = "Задержка скрытия", min = 0, max = 5, step = 0.05 },
		{ type = "Slider", var = "fadeTime", label = "Скорость затухания", min = 0, max = 5, step = 0.05, y = 16 },
		{ type = "Check", var = "hideWorldTips", label = "Мгновенно скрывать подсказки объектов", tip = "Эта опция заставит подсказки, которые появляются от объектов в мире, мгновенно исчезать, когда вы убираете мышь с объекта. Например, почтовые ящики, травы или рудные жилы.\nВНИМАНИЕ! Работает не со всеми объектами." },
	},
	-- Bars
	{
		[0] = "Полосы",
		{ type = "Check", var = "hideDefaultBar", label = "Скрыть полосу здоровья", tip = "Отметьте, чтобы скрыть полосу здоровья по умолчанию?" },
		{ type = "Check", var = "healthBar", label = "Полоса здоровья", tip = "Показать полосу здоровья." },
		{ type = "DropDown", var = "healthBarText", label = "Текст полосы здоровья", list = TipTacDropDowns.BarTextFormat, y = -2 },
		{ type = "Check", var = "healthBarClassColor", label = "Цвет полосы здоровья по классу", tip = "Эта опция окрашивает полосу здоровья в зависимости от класса.", y = 6 },
		{ type = "Color", var = "healthBarColor", label = "Свой цвет полосы здоровья", tip = "Установите свой цвет полосы здоровья. Не действует на игроков с включенной опцией выше.", y = 10 },
		{ type = "Check", var = "manaBar", label = "Полоса маны", tip = "Показать полосу запаса маны, если она есть." },
		{ type = "DropDown", var = "manaBarText", label = "Текст полосы маны", list = TipTacDropDowns.BarTextFormat },
		{ type = "Color", var = "manaBarColor", label = "Свой цвет полосы маны", tip = "Установите свой цвет полосы маны.", y = 10 },
		{ type = "Check", var = "powerBar", label = "Полосы энергии, ярости или силы рун", tip = "Показать полосы энергии, ярости или силу рун." },
		{ type = "DropDown", var = "powerBarText", label = "Текст полосы энергии", list = TipTacDropDowns.BarTextFormat },
	},
	-- Bars Misc
	{
		[0] = "Шрифт",
		{ type = "DropDown", var = "barFontFace", label = "Шрифт", media = "font" },
		{ type = "DropDown", var = "barFontFlags", label = "Контур", list = TipTacDropDowns.FontFlags },
		{ type = "Slider", var = "barFontSize", label = "Размер", min = 6, max = 29, step = 1, y = 36 },
		{ type = "DropDown", var = "barTexture", label = "Текстура", media = "statusbar" },
		{ type = "Slider", var = "barHeight", label = "Высота", min = 1, max = 50, step = 1 },
	},
	-- Auras
	{
		[0] = "Ауры",
		{ type = "Check", var = "aurasAtBottom", label = "Значки де/бафов снизу", tip = "Отобразить значки де/бафов внизу подсказки.", y = 12 },
		{ type = "Check", var = "showBuffs", label = "Показать бафы", tip = "Показать бафы." },
		{ type = "Check", var = "showDebuffs", label = "Показать дебафы", tip = "Показать дебафы.", y = 12 },
		{ type = "Check", var = "selfAurasOnly", label = "Показывать только ваши ауры", tip = "Этот параметр отфильтрует и отобразит только те ауры, которые создали вы.", y = 12 },
		{ type = "Slider", var = "auraSize", label = "Размер значка", min = 8, max = 60, step = 1 },
		{ type = "Slider", var = "auraMaxRows", label = "Количество рядов", min = 1, max = 8, step = 1, y = 8 },
		{ type = "Check", var = "showAuraCooldown", label = "Показать перезарядку", tip = "Показать оставшееся время действия бафов." },
	},
	-- Icon
	{
		[0] = "Значки",
		{ type = "Check", var = "iconRaid", label = "Показать значок рейда", tip = "Показать значок рейда рядом с подсказкой." },
		{ type = "Check", var = "iconFaction", label = "Показать значок фракции", tip = "Показать значок фракции рядом с подсказкой." },
		{ type = "Check", var = "iconCombat", label = "Показать значок боя", tip = "Показывает значок боя рядом с подсказкой, если юнит находится в бою.", y = 12 },
		{ type = "DropDown", var = "iconAnchor", label = "Крепление", list = TipTacDropDowns.AnchorPos },
		{ type = "Slider", var = "iconSize", label = "Размер", min = 8, max = 60, step = 1 },
	},
	-- Anchors
	{
		[0] = "Крепления",
		{ type = "DropDown", var = "anchorWorldUnitType", label = "Игроки и NPS", list = TipTacDropDowns.AnchorType },
		{ type = "DropDown", var = "anchorWorldUnitPoint", label = "Позиция крепления\n (относ. подсказки)", list = TipTacDropDowns.AnchorPos, y = 14 },
		{ type = "DropDown", var = "anchorWorldTipType", label = "Мировые объекты\n (трава, руда и тд.)", list = TipTacDropDowns.AnchorType },
		{ type = "DropDown", var = "anchorWorldTipPoint", label = "Позиция крепления\n (относ. подсказки)", list = TipTacDropDowns.AnchorPos, y = 14 },
		{ type = "DropDown", var = "anchorFrameUnitType", label = "Ваша подсказка", list = TipTacDropDowns.AnchorType },
		{ type = "DropDown", var = "anchorFrameUnitPoint", label = "Позиция крепления\n (относ. подсказки)", list = TipTacDropDowns.AnchorPos, y = 14 },
		{ type = "DropDown", var = "anchorFrameTipType", label = "Подсказки интерфейса", list = TipTacDropDowns.AnchorType },
		{ type = "DropDown", var = "anchorFrameTipPoint", label = "Позиция крепления\n (относ. подсказки)", list = TipTacDropDowns.AnchorPos, y = 14 },
	},
	-- Mouse
	{
		[0] = "Мышь",
		{ type = "Check", var = "mouseTip", label = "Смещение подсказки относительно указателя", y = 16 },
		{ type = "Slider", var = "mouseOffsetX", label = "Смещение по оси X", min = -200, max = 200, step = 1 },
		{ type = "Slider", var = "mouseOffsetY", label = "Смещение по оси Y", min = -200, max = 200, step = 1 },
	},
	-- Combat
	{
		[0] = "Бой",
		{ type = "Check", var = "hideAllTipsInCombat", label = "Скрыть все подсказки в бою", tip = "Эта опция предотвратит отображение подсказок в бою." },
		{ type = "Check", var = "hideUFTipsInCombat", label = "Скрыть подсказки игроков в бою", tip = "Эта опция предотвратит отображение подсказок игроков в бою.", y = 8 },
		{ type = "Check", var = "showHiddenTipsOnShift", label = "Показывать скрытые подсказки при удержании Shift", tip = "Если у вас включена эта опция и одна из вышеперечисленных, вы сможете увидеть подсказки, удерживая клавишу Shift." },
--		{ type = "DropDown", var = "hideCombatTip", label = "Скрыть в бою для", list = { ["Юнит"] = "uf", ["Все"] = "all", ["Нет"] = "none" } },
	},
	-- Layouts
	{
		[0] = "Стиль",
		{ type = "DropDown", label = "Заготовки", init = TipTacDropDowns.LoadLayout_Init, y = 20 },
--		{ type = "Text", label = "Save Layout", func = nil },
--		{ type = "DropDown", label = "Delete Layout", init = TipTacDropDowns.DeleteLayout_Init },
	},
};

-- TipTacTalents Support
if (TipTacTalents) then
	options[#options + 1] = {
		[0] = "Таланты",
		{ type = "Check", var = "showTalents", label = "Показать ветку талантов", tip = "Эта опция покажет ветку талантов у игрока.", y = 12 },
		{ type = "DropDown", var = "talentFormat", label = "Вид", list = { ["Стихии (57/14/00)"] = 1, ["Стихии"] = 2, ["57/14/00"] = 3,}, y = 8 },
		{ type = "Slider", var = "talentCacheSize", label = "Размер кэша", min = 0, max = 50, step = 1 },
	};
end

--------------------------------------------------------------------------------------------------------
--                                          Initialize Frame                                          --
--------------------------------------------------------------------------------------------------------

local f = CreateFrame("Frame",modName.."Options",UIParent);

f:SetWidth(424);
f:SetHeight(360);
f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3 } });
f:SetBackdropColor(0.1,0.22,0.35,1);
f:SetBackdropBorderColor(0.1,0.1,0.1,1);
f:EnableMouse(1);
f:SetMovable(1);
f:SetFrameStrata("DIALOG");
f:SetToplevel(1);
f:SetClampedToScreen(1);
f:SetScript("OnShow",function() f:BuildCategoryPage(); end);
f:Hide();

f.outline = CreateFrame("Frame",nil,f);
f.outline:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f.outline:SetBackdropColor(0.1,0.1,0.2,1);
f.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
f.outline:SetPoint("TOPLEFT",12,-12);
f.outline:SetPoint("BOTTOMLEFT",12,12);
f.outline:SetWidth(84);

f:SetScript("OnMouseDown",function() f:StartMoving() end);
f:SetScript("OnMouseUp",function() f:StopMovingOrSizing(); cfg.optionsLeft = f:GetLeft(); cfg.optionsBottom = f:GetBottom(); end);

if (cfg.optionsLeft) and (cfg.optionsBottom) then
	f:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",cfg.optionsLeft,cfg.optionsBottom);
else
	f:SetPoint("CENTER");
end

f.header = f:CreateFontString(nil,"ARTWORK","GameFontHighlight");
f.header:SetFont(GameFontNormal:GetFont(),22,"THICKOUTLINE");
f.header:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",10,-4);
f.header:SetText(modName.." Options");

f.vers = f:CreateFontString(nil,"ARTWORK","GameFontNormal");
f.vers:SetPoint("TOPRIGHT",-20,-20);
f.vers:SetText(GetAddOnMetadata(modName,"Version"));
f.vers:SetTextColor(1,1,0.5);

local function Reset_OnClick(self)
	for index, tbl in ipairs(options[activePage]) do
		if (tbl.var) then
			cfg[tbl.var] = nil;
		end
	end
	TipTac:ApplySettings();
	f:BuildCategoryPage();
end

f.btnAnchor = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnAnchor:SetWidth(75);
f.btnAnchor:SetHeight(24);
f.btnAnchor:SetPoint("BOTTOMLEFT",f.outline,"BOTTOMRIGHT",10,3);
f.btnAnchor:SetScript("OnClick",function() if (TipTac:IsVisible()) then TipTac:Hide(); else TipTac:Show(); end end);
f.btnAnchor:SetText("Крепление");

f.btnReset = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnReset:SetWidth(75);
f.btnReset:SetHeight(24);
f.btnReset:SetPoint("LEFT",f.btnAnchor,"RIGHT",38,0);
f.btnReset:SetScript("OnClick",Reset_OnClick);
f.btnReset:SetText("Сброс");

f.btnClose = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnClose:SetWidth(75);
f.btnClose:SetHeight(24);
f.btnClose:SetPoint("BOTTOMRIGHT",-15,15);
f.btnClose:SetScript("OnClick",function() f:Hide(); end);
f.btnClose:SetText("Закрыть");

UISpecialFrames[#UISpecialFrames + 1] = f:GetName();

--------------------------------------------------------------------------------------------------------
--                                        Options Category List                                       --
--------------------------------------------------------------------------------------------------------

local listButtons = {};

local function List_OnClick(self,button)
	listButtons[activePage].text:SetTextColor(1,0.82,0);
	listButtons[activePage]:UnlockHighlight();
	activePage = self.index;
	self.text:SetTextColor(1,1,1);
	self:LockHighlight();
	PlaySound("igMainMenuOptionCheckBoxOn");
	f:BuildCategoryPage();
end

local buttonWidth = (f.outline:GetWidth() - 8);
local function MakeListEntry()
	local b = CreateFrame("Button",nil,f.outline);
	b:SetWidth(buttonWidth);
	b:SetHeight(18);
	b:SetScript("OnClick",List_OnClick);
	b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	b:GetHighlightTexture():SetAlpha(0.7);
	b.text = b:CreateFontString(nil,"ARTWORK","GameFontNormal");
	b.text:SetPoint("LEFT",3,0);
	listButtons[#listButtons + 1] = b;
	return b;
end

local button;
for index, table in ipairs(options) do
	button = listButtons[index] or MakeListEntry();
	button.text:SetText(table[0]);
	button.index = index;
	if (index == 1) then
		button:LockHighlight();
		button.text:SetTextColor(1,1,1);
		button:SetPoint("TOPLEFT",f.outline,"TOPLEFT",5,-6);
	else
		button:SetPoint("TOPLEFT",listButtons[index - 1],"BOTTOMLEFT");
	end
end

--------------------------------------------------------------------------------------------------------
--                                        Build Option Category                                       --
--------------------------------------------------------------------------------------------------------

local function ChangeSettingFunc(self,var,value)
	if (not ignoreConfigUpdate) then
		cfg[var] = value;
		TipTac:ApplySettings();
	end
end

local factory = AzOptionsFactory:New(f,nil,ChangeSettingFunc);

-- Build Page
function f:BuildCategoryPage()
	AzDropDown:HideMenu();
	factory:ResetObjectUse();
	local frame;
	local yOffset = -38;
	-- Loop Through Options
	ignoreConfigUpdate = 1;
	for index, option in ipairs(options[activePage]) do
		-- Init & Setup the Frame
		frame = factory:GetObject(option.type);
		frame.option = option;
		frame.text:SetText(option.label);
		-- slider
		if (option.type == "Slider") then
			frame.slider:SetMinMaxValues(option.min,option.max);
			frame.slider:SetValueStep(option.step);
			frame.slider:SetValue(cfg[option.var]);
			frame.edit:SetNumber(cfg[option.var]);
			frame.low:SetText(option.min);
			frame.high:SetText(option.max);
		-- check
		elseif (option.type == "Check") then
			frame:SetHitRectInsets(0,frame.text:GetWidth() * -1,0,0);
			frame:SetChecked(cfg[option.var]);
		-- color
		elseif (option.type == "Color") then
			frame:SetHitRectInsets(0,frame.text:GetWidth() * -1,0,0);
			if (option.subType == 2) then
				frame.color[1], frame.color[2], frame.color[3], frame.color[4] = factory:HexStringToRGBA(cfg[option.var]);
			else
				frame.color[1], frame.color[2], frame.color[3], frame.color[4] = unpack(cfg[option.var]);
			end
			frame.texture:SetVertexColor(frame.color[1],frame.color[2],frame.color[3],frame.color[4] or 1);
		-- dropdown
		elseif (option.type == "DropDown") then
			frame.InitFunc = (option.init or option.media and TipTacDropDowns.SharedMediaLib_Init or TipTacDropDowns.Default_Init);
			frame:InitSelectedItem(cfg[option.var]);
		-- text
		elseif (option.type == "Text") then
			frame:SetText(cfg[option.var]:gsub("|","||"));
		end
		-- Anchor the Frame
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",factory.objectOffsetX[option.type] + (option.x or 0),yOffset);
		yOffset = (yOffset - frame:GetHeight() - factory.objectOffsetY[option.type] - (option.y or 0));
		-- Show
		frame:Show();
	end
	-- End Update
	ignoreConfigUpdate = nil;
end