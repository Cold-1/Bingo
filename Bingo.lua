local Bingo = {
	ADDON_NAME = ...,
	ADDON_NAMESPACE = select(2, ...),
	BingoButtons = {},
	DefaultBackdrop = {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		edgeSize = 32,
		insets = { left = 8, right = 8, top = 8, bottom = 8, },
	}
}

function Bingo:Init()
	self.VERSION = GetAddOnMetadata(self.ADDON_NAME, "Version")
	
	SlashCmdList[strupper(self.ADDON_NAME)] = self.SlashCmdHandler
	SLASH_BINGO1 = "/" .. strlower(self.ADDON_NAME)
	
	self:CreateFrames()
	self:CreateButtons()
	self.BingoFrame:Show()
end

function Bingo.LoadDefaultSettings()
	BingoSettings = {
		PrintVersionOnLoad = false,
		Scale = 1,
		DefaultCard = "Default",
		LoadOnImport = true
	}
end

function Bingo.LoadDefaultBingoCards()
	BingoCards = {
		Default = {
			Title = "Default Bingo Card",
			FontSize = 24,
			FreeSpaceSize = 20
		},
		
		Example = {
			Title = "Example Bingo Card",
			TitleSize = 28,
			FontSize = 12,
			FreeSpace = "This is the Free Space!",
			FreeSpaceSize = 14,
			[1] = "Example Bingo Space 1",
			[2] = "Example Bingo Space 2",
			[3] = "Example Bingo Space 3",
			[4] = "Example Bingo Space 4",
			[5] = "Example Bingo Space 5",
			[6] = "Example Bingo Space 6",
			[7] = "Example Bingo Space 7",
			[8] = "Example Bingo Space 8",
			[9] = "Example Bingo Space 9",
			[10] = "Example Bingo Space 10 with a custom size!",
			Size10 = 10,
			[11] = "Example Bingo Space 11",
			[12] = "Example Bingo Space 12",
			[13] = "Example Bingo Space 13",
			[14] = "Example Bingo Space 14",
			[15] = "Example Bingo Space 15",
			[16] = "Example Bingo Space 16 has a custom size too!",
			Size16 = 8,
			[17] = "Example Bingo Space 17",
			[18] = "Example Bingo Space 18",
			[19] = "Example Bingo Space 19",
			[20] = "Example Bingo Space 20",
			[21] = "Example Bingo Space 21",
			[22] = "Example Bingo Space 22",
			[23] = "Example Bingo Space 23",
			[24] = "Example Bingo Space 24",
			[25] = "This is the Free Space!!!",
			Size25 = 8
		}
	}
end

function Bingo.EventHandler(_, event, ...)
	local arg1 = ...
	if ((event == "ADDON_LOADED") and (arg1 == Bingo.ADDON_NAME)) then
		if not BingoSettings then
			Bingo.LoadDefaultSettings()
		else
			Bingo.BingoFrame:SetScale(BingoSettings.Scale)
		end
		
		if not BingoCards then
			Bingo.LoadDefaultBingoCards()
		end
	
		if BingoSettings.PrintVersionOnLoad then
			print("|cffFFC125" .. Bingo.ADDON_NAME .. "|cffffffff " .. Bingo.VERSION .. "|cff00ff00 Loaded")
		end
		
		Bingo:LoadBingoCard(BingoSettings.DefaultCard or "Default")
	end
end

function Bingo.SlashCmdHandler(message)
	message = strtrim(message or "")
	
	local splitMessage = {}
	for s in string.gmatch(message, "%S+") do
		splitMessage[#splitMessage + 1] = s
	end
	
	local cmd = strlower(splitMessage[1] or "")
	
	if (cmd == "help") then
		print("|cff00ccff#####|cffFFC125 " .. Bingo.ADDON_NAME .. "|cffffffff Help |cff00ccff#####")
		print("|cffFFFFE0/bingo |cffffffff- Toggle the bingo card window.")
		print("|cffFFFFE0/bingo|cffADFF2F version |cffffffff- Print the addon version.")
		print("|cffFFFFE0/bingo|cffADFF2F show |cffffffff- Show the bingo card window.")
		print("|cffFFFFE0/bingo|cffADFF2F hide |cffffffff- Hide the bingo card window.")
		print("|cffFFFFE0/bingo|cffADFF2F resetcards |cffffffff- Reset all saved cards back to the default.")
		print("|cffFFFFE0/bingo|cffADFF2F resetsettings |cffffffff- Reset all settings back to the default.")
		print("|cffFFFFE0/bingo|cffADFF2F printversion |cffffffff- Enable/Disable printing the addon version on load. Default is disabled.")
		print("|cffFFFFE0/bingo|cffADFF2F defaultcard |cff71C671<Card Name> |cffffffff- Sets the card that will be loaded by default.")
		print("|cffFFFFE0/bingo|cffADFF2F scale |cff71C671<Number> |cffffffff- Scales the interface by the specified amount. Default is 1. Numbers only, decimals accepted.")
		print("|cffFFFFE0/bingo|cffADFF2F list |cffffffff- List all the saved bingo cards.")
		print("|cffFFFFE0/bingo|cffADFF2F load |cff71C671<Card Name> |cffffffff- Loads the specified card, the card name is case-sensitive.")
	elseif (cmd == "load") then
		if splitMessage[2] then
			local i = 2
			local cardName = ""
			
			while splitMessage[i] do
				cardName = cardName .. splitMessage[i] .. " "
				i = i + 1
			end
			
			cardName = strtrim(cardName)
			
			if Bingo:LoadBingoCard(cardName) then
				Bingo.BingoFrame:Show()
			else
				print("|cffff0000Error!|cffffffff Failed to load |cffFFFFE0'" .. cardName .. "'|cffffffff, misspelled name |cffADFF2F(case-sensitive)|cffffffff or card does not exist.")
			end
		else
			print("|cffff0000Error!|cffffffff You must specify the name |cffADFF2F(case-sensitive)|cffffffff of the card you want to load.|cff00ccff Example: |cffffffff'/bingo load Default' - |cffffff00Tip:|cffffffff To view cards: '/bingo list'")
		end
	elseif (cmd == "list") then
		print("|cffFFC125Bingo cards:")
		for i in pairs(BingoCards) do
			print(" - " .. i)
		end
	elseif (cmd == "scale") then
		if (splitMessage[2] and (splitMessage[2]:match("%d+"))) then
			BingoSettings.Scale = tonumber(splitMessage[2])
			Bingo.BingoFrame:SetScale(BingoSettings.Scale)
			print("|cffFFC125Bingo setting: |cffFFFFE0'Scale'|cffffffff set to " .. splitMessage[2])
		else
			if splitMessage[2] then
				print("|cffff0000Error!|cffffffff Invalid scale value |cffADFF2F(number)|cffffffff: |cffFFFFE0'" .. splitMessage[2] .. "'")
			else
				print("|cffff0000Error!|cffffffff You must specify the scale value |cffADFF2F(number).|cff00ccff Example: |cffffffff '/bingo scale 1.5'")
			end
		end
	elseif (cmd == "printversion") then
		BingoSettings.PrintVersionOnLoad = not BingoSettings.PrintVersionOnLoad
		if BingoSettings.PrintVersionOnLoad then
			print("|cffFFC125Bingo setting: |cffFFFFE0'Print version on load'|cff00ff00 Enabled")
		else
			print("|cffFFC125Bingo setting: |cffFFFFE0'Print version on load'|cffff0000 Disabled")
		end
	elseif (cmd == "defaultcard") then
		if splitMessage[2] then
			if BingoCards[splitMessage[2]] then
				BingoSettings.DefaultCard = splitMessage[2]
				print("|cffFFC125Bingo setting: |cffFFFFE0'" .. splitMessage[2].. "'|cffffffff set as default card")
			else
				print("|cffff0000Error!|cffffffff Failed to find |cffFFFFE0'" .. splitMessage[2] .. "'|cffffffff, misspelled name |cffADFF2F(case-sensitive)|cffffffff or card does not exist.")
			end
		else
			print("|cffff0000Error!|cffffffff You must specify the name |cffADFF2F(case-sensitive)|cffffffff of the card you want to set as default.|cff00ccff Example: |cffffffff'/bingo defaultcard Default' - |cffffff00Tip:|cffffffff To view cards: '/bingo list'")
		end
	elseif (cmd == "resetcards") then
		Bingo.LoadDefaultBingoCards()
		print("|cffff6060Bingo cards have been reset.")
	elseif (cmd == "resetsettings") then
		Bingo.LoadDefaultSettings()
		Bingo.BingoFrame:SetScale(BingoSettings.Scale)
		print("|cffff6060Bingo settings have been reset.")
	elseif (cmd == "show") then
		Bingo.BingoFrame:Show()
	elseif (cmd == "hide") then
		Bingo.BingoFrame:Hide()
	elseif (cmd == "version") then
		print("|cffFFC125" .. Bingo.ADDON_NAME .. "|cffffffff version: " .. Bingo.VERSION)
	elseif (cmd == "") then
		if Bingo.BingoFrame:IsShown() then
			Bingo.BingoFrame:Hide()
		else
			Bingo.BingoFrame:Show()
		end
	else
		print("|cffff0000Error!|cffffffff Invalid command |cffFFFFE0'" .. message .. "'|cffffffff. |cffffff00Tip:|cffffffff Use '/bingo help' to view a list of commands.")
	end
end

function Bingo:CreateFrames()
	-- Create main bingo frame aka the game frame
	self.BingoFrame = CreateFrame("Frame", "BingoFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	self.BingoFrame:Hide()

	-- Register events
	self.BingoFrame:SetScript("OnEvent", self.EventHandler)
	self.BingoFrame:SetScript("OnDragStart", self.BingoFrame.StartMoving)
	self.BingoFrame:SetScript("OnDragStop", self.BingoFrame.StopMovingOrSizing)
	
	self.BingoFrame:RegisterEvent("ADDON_LOADED")
	
	-- Customize main frame
	self.BingoFrame:SetFrameLevel(4)
	self.BingoFrame:SetMovable(true)
	self.BingoFrame:EnableMouse(true)
	self.BingoFrame:RegisterForDrag("LeftButton")

	self.BingoFrame:SetWidth(430)
	self.BingoFrame:SetHeight(500)
	self.BingoFrame:ClearAllPoints()
	self.BingoFrame:SetPoint("CENTER")
	self.BingoFrame:SetBackdrop(self.DefaultBackdrop)
	tinsert(UISpecialFrames, self.BingoFrame:GetName())
	
	-- Add bingo card title text to main frame
	self.BingoFrame.text = self.BingoFrame:CreateFontString(nil, "OVERLAY")
	self.BingoFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 32, "OUTLINE")
	self.BingoFrame.text:SetPoint("TOPLEFT", 15, -55)
	self.BingoFrame.text:SetPoint("BOTTOMRIGHT", -15, 430)
	self.BingoFrame.text:SetText("Bingo!")
	
	-- Add close button to main frame
	self.BingoFrameCloseButton = CreateFrame("Button", "BingoFrameCloseButton", self.BingoFrame, "UIPanelCloseButton")
	self.BingoFrameCloseButton:SetPoint("TOPRIGHT", -10, -10)
	self.BingoFrameCloseButton:SetScript("OnClick", function()
		self.BingoFrame:Hide()
	end)
	
	-- Create confirmation popup for reset button
	local resetCard = function(self)
		local cardID = tonumber(self.editBox:GetText())
		if ((not cardID) or (cardID < 1) or (cardID > 25)) then
			print("|cffff0000Error!|cffffffff Invalid card ID |cffADFF2F(number, between 1-25)|cffffffff: |cffFFFFE0'" .. self.editBox:GetText() .. "'")
		else
			Bingo.BingoButtons[cardID]:Enable()
			Bingo.CurrentBingoCardBingo = Bingo:CheckForBingo()
		end
	end
	
	StaticPopupDialogs["BINGO_RESET_DIALOG"] = {
		text = "Enter the card ID you wish to reset.",
		button1 = RESET,
		button2 = CANCEL,
		timeout = 0,
		whileDead = true,
		hasEditBox = true,
		autoFocus = true,
		OnAccept = resetCard,
		OnShow = function(self)
			self.button1:Disable()
			for i, b in pairs(Bingo.BingoButtons) do
				b:SetText(i)
				b.text:Hide()
			end
		end,
		OnHide = function(self)
			for i, b in pairs(Bingo.BingoButtons) do
				b:SetText("")
				b.text:Show()
			end
		end,
		EditBoxOnTextChanged = function(self) 
			if (self:GetText() == "") then
				self:GetParent().button1:Disable()
			else
				self:GetParent().button1:Enable()
			end
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			if self:GetParent().button1:IsEnabled() then
				resetCard(self:GetParent())
				self:GetParent():Hide()
			end
		end
	}
	
	-- Add reset button to the main frame
	self.ResetButton = CreateFrame("Button", "BingoResetButton", self.BingoFrame, "UIPanelButtonTemplate")
	self.ResetButton:SetSize(70, 25)
	self.ResetButton:SetPoint("TOPLEFT", 15, -15)
	self.ResetButton:SetText("Reset")
	self.ResetButton:SetScript("OnClick", function()
		StaticPopup_Show("BINGO_RESET_DIALOG")
	end)
	
	-- Create confirmation popup for reset all button
	StaticPopupDialogs["BINGO_RESETALL_DIALOG"] = {
		text = "Are you sure you want to reset the bingo card?",
		button1 = YES,
		button2 = NO,
		timeout = 0, 		
		whileDead = true,
		hideOnEscape = true,
		enterClicksFirstButton = true,
		OnAccept = function()
			for _, b in pairs(self.BingoButtons) do
				b:Enable()
			end
			self.CurrentBingoCardBingo = false
		end
	}
	
	-- Add reset all button to the main frame
	self.ResetAllButton = CreateFrame("Button", "BingoResetAllButton", self.BingoFrame, "UIPanelButtonTemplate")
	self.ResetAllButton:SetSize(70, 25)
	self.ResetAllButton:SetPoint("TOPLEFT", 90, -15)
	self.ResetAllButton:SetText("Reset All")
	self.ResetAllButton:SetScript("OnClick", function()
		StaticPopup_Show("BINGO_RESETALL_DIALOG")
	end)
	
	-- Add import button to the main frame
	self.ImportButton = CreateFrame("Button", "BingoImportButton", self.BingoFrame, "UIPanelButtonTemplate")
	self.ImportButton:SetSize(70, 25)
	self.ImportButton:SetPoint("TOPLEFT", 165, -15)
	self.ImportButton:SetText("Import")
	self.ImportButton:SetScript("OnClick", function()
		self.BingoEditBox:SetText("")
		self.BingoSaveButton:Show()
		self.BingoSelectAllButton:Hide()
		self.BingoFrame:Hide()
		self.BingoEditFrame:Show()
	end)
	
	-- Add export button to the main frame
	self.ImportButton = CreateFrame("Button", "BingoExportButton", self.BingoFrame, "UIPanelButtonTemplate")
	self.ImportButton:SetSize(70, 25)
	self.ImportButton:SetPoint("TOPLEFT", 240, -15)
	self.ImportButton:SetText("Export")
	self.ImportButton:SetScript("OnClick", function()
		if self.CurrentBingoCard then
			self.BingoEditBox:SetText(Bingo.ADDON_NAMESPACE.serpent.block(BingoCards[self.CurrentBingoCard], { sparse = true, comment = false }))
			self.BingoEditBox:HighlightText()
			self.BingoSaveButton:Hide()
			self.BingoSelectAllButton:Show()
			self.BingoFrame:Hide()
			self.BingoEditFrame:Show()
			self.BingoEditBox:SetFocus(true)
		else
			print("|cffff0000Error!|cffffffff Load a card before trying to export.")
		end
	end)
	
	-- Create confirmation popup for shuffle button
	StaticPopupDialogs["BINGO_SHUFFLE_DIALOG"] = {
		text = "Shuffling the bingo card will also reset all spaces, do you wish to continue?",
		button1 = YES,
		button2 = NO,
		timeout = 0, 		
		whileDead = true,
		hideOnEscape = true,
		enterClicksFirstButton = true,
		OnAccept = function()
			Bingo:LoadBingoCard(Bingo.CurrentBingoCard)
		end
	}
	
	-- Add shuffle button to the main frame
	self.ShuffleButton = CreateFrame("Button", "BingoShuffleButton", self.BingoFrame, "UIPanelButtonTemplate")
	self.ShuffleButton:SetSize(70, 25)
	self.ShuffleButton:SetPoint("TOPLEFT", 315, -15)
	self.ShuffleButton:SetText("Shuffle")
	self.ShuffleButton:SetScript("OnClick", function()
		StaticPopup_Show("BINGO_SHUFFLE_DIALOG")
	end)
	
	-- Create the import/export frame
	self.BingoEditFrame = CreateFrame("Frame", "BingoEditFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	self.BingoEditFrame:SetScript("OnDragStart", self.BingoEditFrame.StartMoving)
	self.BingoEditFrame:SetScript("OnDragStop", self.BingoEditFrame.StopMovingOrSizing)
	
	self.BingoEditFrame:SetFrameLevel(40)
	self.BingoEditFrame:SetMovable(true)
	self.BingoEditFrame:EnableMouse(true)
	self.BingoEditFrame:RegisterForDrag("LeftButton")
	
	self.BingoEditFrame:SetPoint("CENTER")
	self.BingoEditFrame:SetWidth(400)
	self.BingoEditFrame:SetHeight(400)
	self.BingoEditFrame:SetResizable(true)
	self.BingoEditFrame:SetMinResize(250, 250)
	self.BingoEditFrame:SetBackdrop(self.DefaultBackdrop)
	tinsert(UISpecialFrames, self.BingoEditFrame:GetName())
	
	-- Add a scroll frame to the import/export frame
	self.BingoScrollFrame = CreateFrame("ScrollFrame", "BingoScrollFrame", self.BingoEditFrame, "UIPanelScrollFrameTemplate")
	self.BingoScrollFrame:SetPoint("TOPLEFT", 12, -12)
	self.BingoScrollFrame:SetPoint("BOTTOMRIGHT", -34, 49)
	
	-- Add the edit box to the scroll frame
	self.BingoEditBox = CreateFrame("EditBox", "BingoEditBox", self.BingoScrollFrame)
	self.BingoEditBox:SetMultiLine(true)
	self.BingoEditBox:SetAutoFocus(false)
	self.BingoEditBox:SetFontObject("ChatFontNormal")
	self.BingoEditBox:SetScript("OnEscapePressed", function() 
		self.BingoEditBox:ClearFocus()
	end)
	
	-- Set focus to edit box when user clicks on any part of the scroll frame
	self.BingoScrollFrame:SetScrollChild(self.BingoEditBox)
	self.BingoScrollFrame:SetScript("OnMouseDown", function() 
		self.BingoEditBox:SetFocus(true)
	end)
	
	-- Adjust edit box width when edit frame is shown to make sure text will not go off frame
	self.BingoEditFrame:SetScript("OnShow", function() 
		Bingo.BingoEditBox:SetWidth(Bingo.BingoScrollFrame:GetWidth())
	end)

	-- Create enter name popup before saving
	local saveCard = function(self) 
		if (Bingo.BingoEditBox:GetText() == "") then
			print("|cffff0000Error!|cffffffff Can't save nothing.")
			return
		end
		
		local ok, card
		
		if (string.find(Bingo.BingoEditBox:GetText(), "{") and string.find(Bingo.BingoEditBox:GetText(), "}")) then
			ok, card = Bingo.ADDON_NAMESPACE.serpent.load(Bingo.BingoEditBox:GetText())
		end
		
		if ok then
			BingoCards[self.editBox:GetText()] = card
			Bingo.BingoEditFrame:Hide()
			Bingo.BingoFrame:Show()
			print("|cffFFC125" .. Bingo.ADDON_NAME .. "|cffffffff card |cffFFFFE0'" .. self.editBox:GetText() .. "'|cffffffff saved.")
			if BingoSettings.LoadOnImport then
				Bingo.LoadBingoCard(self.editBox:GetText())
			end
		else
			print("|cffff0000Error!|cffffffff Unable to save card |cffFFFFE0'" .. self.editBox:GetText() .. "'|cffffffff, check the import string is properly formatted.")
		end
	end
	
	StaticPopupDialogs["BINGO_SAVE_DIALOG"] = {
		text = "Enter a name for this card.\n\n|cffff6060Entering an existing name will overwrite that card",
		button1 = SAVE,
		button2 = CANCEL,
		timeout = 0,
		whileDead = true,
		hasEditBox = true,
		autoFocus = true,
		OnAccept = saveCard,
		OnShow = function(self)
			self.button1:Disable()
		end,
		EditBoxOnTextChanged = function(self) 
			if (self:GetText() == "") then
				self:GetParent().button1:Disable()
			else
				self:GetParent().button1:Enable()
			end
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			if self:GetParent().button1:IsEnabled() then
				saveCard(self:GetParent())
				self:GetParent():Hide()
			end
		end
	}
	
	-- Add close button to the import/export frame
	self.BingoCloseButton = CreateFrame("Button", "BingoCloseButton", self.BingoEditFrame, "UIPanelButtonTemplate")
	self.BingoCloseButton:SetSize(75, 20)
	self.BingoCloseButton:SetPoint("BOTTOMRIGHT", -75, 19)
	self.BingoCloseButton:SetText("Close")
	self.BingoCloseButton:SetScript("OnClick", function()
		self.BingoEditFrame:Hide()
		self.BingoFrame:Show()
	end)
	
	-- Add save button to the import/export frame
	self.BingoSaveButton = CreateFrame("Button", "BingoSaveButton", self.BingoEditFrame, "UIPanelButtonTemplate")
	self.BingoSaveButton:SetSize(75, 20)
	self.BingoSaveButton:SetPoint("BOTTOMLEFT", 75, 19)
	self.BingoSaveButton:SetText(SAVE)
	self.BingoSaveButton:SetScript("OnClick", function()
		self.BingoEditBox:ClearFocus()
		StaticPopup_Show("BINGO_SAVE_DIALOG")
	end)
	self.BingoSaveButton:Hide()

	-- Add select all button to the import/export frame
	self.BingoSelectAllButton = CreateFrame("Button", "BingoSelectAllButton", self.BingoEditFrame, "UIPanelButtonTemplate")
	self.BingoSelectAllButton:SetSize(75, 20)
	self.BingoSelectAllButton:SetPoint("BOTTOMLEFT", 75, 19)
	self.BingoSelectAllButton:SetText("Select All")
	self.BingoSelectAllButton:SetScript("OnClick", function()
		self.BingoEditBox:HighlightText()
	end)
	self.BingoSelectAllButton:Hide()
	
	-- Add resize button to the import/export frame
	self.BingoEditFrameResizeButton = CreateFrame("Button", "BingoEditFrameResizeButton", self.BingoEditFrame)
	self.BingoEditFrameResizeButton:SetSize(16, 16)
	self.BingoEditFrameResizeButton:SetPoint("BOTTOMRIGHT", -9, 8)
	
	self.BingoEditFrameResizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	self.BingoEditFrameResizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	self.BingoEditFrameResizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	
	self.BingoEditFrameResizeButton:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton") then
			Bingo.BingoEditFrame:StartSizing("BOTTOMRIGHT")
			self:GetHighlightTexture():Hide()
		end
	end)
	self.BingoEditFrameResizeButton:SetScript("OnMouseUp", function(self, button)
		if (button == "LeftButton") then
			self:GetHighlightTexture():Show()
			Bingo.BingoEditFrame:StopMovingOrSizing()
			Bingo.BingoEditBox:SetWidth(Bingo.BingoScrollFrame:GetWidth())
		end
	end)
	
	-- Create confirmation popup for when game is won
	StaticPopupDialogs["BINGO_WIN_DIALOG"] = {
		text = "|cffFFC125BINGO!|cffffffff Congratulations, you won! Would you like to reset the card?",
		button1 = YES,
		button2 = NO,
		timeout = 0, 		
		whileDead = true,
		hideOnEscape = true,
		enterClicksFirstButton = true,
		OnAccept = function()
			for _, b in pairs(self.BingoButtons) do
				b:Enable()
			end
			self.CurrentBingoCardBingo = false
		end
	}

	self.CreateFrame = function() end
end

function Bingo:CreateButton(x, y, name)
	local bingoButton
	
	bingoButton = CreateFrame("Button", name, self.BingoFrame, "UIPanelButtonTemplate")
	bingoButton:SetSize(80, 80)
	bingoButton:SetPoint("TOPLEFT", x, y)
	
	bingoButton:SetNormalTexture("Interface\\AddOns\\Bingo\\Imgs\\ButtonNormal.tga")
	bingoButton:SetPushedTexture("Interface\\AddOns\\Bingo\\Imgs\\ButtonPushed.tga")
	bingoButton:SetDisabledTexture("Interface\\AddOns\\Bingo\\Imgs\\ButtonDisabled.tga")
	bingoButton:SetHighlightTexture("Interface\\AddOns\\Bingo\\Imgs\\ButtonHighlight.tga")
	bingoButton:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
	
	bingoButton.text = bingoButton:CreateFontString(nil, "OVERLAY")
	bingoButton.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
	bingoButton.text:SetPoint("TOPLEFT", 5, -5)
	bingoButton.text:SetPoint("BOTTOMRIGHT", -5, 5)

	bingoButton:SetScript("OnClick", function()
		bingoButton:Disable()
		if not self.CurrentBingoCardBingo then
			if self:CheckForBingo() then
				StaticPopup_Show("BINGO_WIN_DIALOG")
			end
		end
	end)
	
	return bingoButton
end

function Bingo:CreateButtons()
	local buttonCounter = 1
	local xoffset = 15
	local yoffset = -85

	for i=1, 5 do
		local xoff = xoffset
		
		for i=1, 5 do
			self.BingoButtons[buttonCounter] = self:CreateButton(xoff, yoffset, "BingoButton" .. buttonCounter)
			xoff = xoff + 80
			buttonCounter = buttonCounter + 1
		end
		
		xoff = xoffset
		yoffset = yoffset - 80
	end

	self.CreateButton = function() end
	self.CreateButtons = function() end
end

function Bingo:LoadBingoCard(cardName)
	if BingoCards[cardName] then		
		-- Create a table with numbers 1-24, one for each bingo card. Used when randomizing to keep track of cards
		local bingoCards = {}
		for i=1, 24 do
			bingoCards[i] = i
		end

		-- Load card title
		self.BingoFrame.text:SetFont("Fonts\\FRIZQT__.TTF", BingoCards[cardName]["TitleSize"] or 20, "OUTLINE")
		self.BingoFrame.text:SetText(BingoCards[cardName]["Title"] or "Bingo!")
		
		-- Load button text and size and randomize button positions, we skip 13 because it's the center/free button
		local randomCard		
		for i=1, 12 do
			randomCard = math.random(#bingoCards)
			self:LoadButton(cardName, i, bingoCards[randomCard])
			tremove(bingoCards, randomCard)
		end
		for i=14, 25 do
			randomCard = math.random(#bingoCards)
			self:LoadButton(cardName, i, bingoCards[randomCard])
			tremove(bingoCards, randomCard)
		end
		-- Set center/free button text and size
		self.BingoButtons[13].text:SetText(BingoCards[cardName]["FreeSpace"] or BingoCards[cardName][25] or "Free Space")
		self.BingoButtons[13].text:SetFont("Fonts\\FRIZQT__.TTF", (BingoCards[cardName]["FreeSpaceSize"] or BingoCards[cardName]["Size25"] or BingoCards[cardName]["FontSize"] or 10), "OUTLINE")
		self.BingoButtons[13]:Enable()

		self.CurrentBingoCard = cardName
		self.CurrentBingoCardBingo = false

		return true
	else
		return false
	end
end

function Bingo:LoadButton(cardName, buttonID, cardID)
	local text = BingoCards[cardName][cardID]
	if (text and (type(text) == "string")) then
		text = cardID .. ". " .. text
	else
		text = cardID
	end
	
	self.BingoButtons[buttonID].text:SetText(text)
	self.BingoButtons[buttonID].text:SetFont("Fonts\\FRIZQT__.TTF", (BingoCards[cardName]["Size"..cardID] or BingoCards[cardName]["FontSize"] or 10), "OUTLINE")
	self.BingoButtons[buttonID]:Enable()
end

function Bingo:CheckForBingo()
	local offset
	for i=0, 4 do
		-- Check for horizontal bingo
		offset = 5 * i
		if not (self.BingoButtons[1 + offset]:IsEnabled() 
		or self.BingoButtons[2 + offset]:IsEnabled() 
		or self.BingoButtons[3 + offset]:IsEnabled() 
		or self.BingoButtons[4 + offset]:IsEnabled() 
		or self.BingoButtons[5 + offset]:IsEnabled()) then
			self.CurrentBingoCardBingo = true
			return true
		-- Check for vertical bingo
		elseif not (self.BingoButtons[1 + i]:IsEnabled() 
		or self.BingoButtons[6 + i]:IsEnabled() 
		or self.BingoButtons[11 + i]:IsEnabled() 
		or self.BingoButtons[16 + i]:IsEnabled() 
		or self.BingoButtons[21 + i]:IsEnabled()) then
			self.CurrentBingoCardBingo = true
			return true
		end 
	end
	
	-- Check for diagonal bingo
	if not (self.BingoButtons[1]:IsEnabled() 
	or self.BingoButtons[7]:IsEnabled() 
	or self.BingoButtons[13]:IsEnabled() 
	or self.BingoButtons[19]:IsEnabled() 
	or self.BingoButtons[25]:IsEnabled()) then
		self.CurrentBingoCardBingo = true
		return true
	elseif not (self.BingoButtons[5]:IsEnabled() 
	or self.BingoButtons[9]:IsEnabled() 
	or self.BingoButtons[13]:IsEnabled() 
	or self.BingoButtons[17]:IsEnabled() 
	or self.BingoButtons[21]:IsEnabled()) then
		self.CurrentBingoCardBingo = true
		return true
	end
	
	return false
end

Bingo:Init()
