-- A combo box consists of a text control, a button to expand it, and a dropdown selectable list
-- this is a custom control as it its default has very game specific look to it
-- Combo box will need to have its width set, but height will be auto based on the bitmaps

local LazyVar = import('/lua/lazyvar.lua')
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Text = import('/lua/maui/text.lua').Text
local ItemList = import('/lua/maui/itemlist.lua').ItemList
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
--local Dragger = import('/lua/maui/dragger.lua').Dragger
local UIMain = import('/lua/ui/uimain.lua')

local activeCombo = nil

local defaultBitmaps = {
    button = {
        left = {
            up = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_up_l.dds'),
            down = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_down_l.dds'),
            over = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_over_l.dds'),
            dis = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_dis_l.dds'),
        },
        mid = {
            up = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_up_m.dds'),
            down = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_down_m.dds'),
            over = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_over_m.dds'),
            dis = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_dis_m.dds'),
        },
        right = {
            up = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_up_r.dds'),
            down = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_down_r.dds'),
            over = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_over_r.dds'),
            dis = UIUtil.SkinnableFile('/widgets/drop-down/drop_btn_dis_r.dds'),
        }
    },
    list = {
       ul = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_ul.dds'),
       um = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_horz_um.dds'),
       ur = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_ur.dds'),
       l = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_vert_l.dds'),
       m = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_m.dds'),
       r = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_vert_r.dds'),
       ll = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_ll.dds'),
       lm = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_lm.dds'),
       lr = UIUtil.SkinnableFile('/widgets/drop-down/drop-box_brd_lr.dds'),
    },
}


Combo = Class(Group) {
    __init = function(self, parent, pointSize, maxVisibleItems, staticTitle, bitmaps, rolloverCue, clickCue, itemCue, debugName)
        Group.__init(self, parent)
        self:SetName(debugName or "Combo")
        self.mRolloverCue = rolloverCue
        self.mClickCue = clickCue
        self.mItemCue = itemCue or "UI_Tab_Click_01"

        bitmaps = bitmaps or defaultBitmaps

        pointSize = pointSize or 12
        maxVisibleItems = maxVisibleItems or 10

        -- this sets if the title is fixed or changes when a new selection is made
        self._staticTitle = staticTitle

        self._btnLeft = Bitmap(self, bitmaps.button.left.up)
        self._btnRight = Bitmap(self, bitmaps.button.right.up)
        self._btnMid = Bitmap(self, bitmaps.button.mid.up)
        self._btnLeft:DisableHitTest()
        self._btnRight:DisableHitTest()
        self._btnMid:DisableHitTest()

        LayoutHelpers.AtLeftTopIn(self._btnLeft, self)
        LayoutHelpers.AtRightTopIn(self._btnRight, self)
        LayoutHelpers.AtTopIn(self._btnMid, self)
        self._btnMid.Left:Set(self._btnLeft.Right)
        self._btnMid.Right:Set(self._btnRight.Left)

        self._text = UIUtil.CreateText(self._btnMid, "", pointSize, UIUtil.bodyFont)
        self._text:DisableHitTest()

        -- text control is height of text/font, and from left to button
        self.Height:Set(function() return math.max(self._text.Height(), self._btnMid.Height()) end)
        LayoutHelpers.AtVerticalCenterIn(self._text, self._btnMid, 1)
        LayoutHelpers.AtLeftIn(self._text, self._btnLeft, 5)
        LayoutHelpers.AtRightIn(self._text, self._btnMid, -5)
        self._text:SetClipToWidth(true)

        self._dropdown = Group(self._text)
        self._dropdown.Top:Set(self.Bottom)
        self._dropdown.Right:Set(self.Right)
        self._dropdown.Width:Set(function() return self.Width() - LayoutHelpers.ScaleNumber(5) end)

        local ddul = Bitmap(self._dropdown, bitmaps.list.ul)
        local ddum = Bitmap(self._dropdown, bitmaps.list.um)
        local ddur = Bitmap(self._dropdown, bitmaps.list.ur)
        local ddl = Bitmap(self._dropdown, bitmaps.list.l)
        local ddm = Bitmap(self._dropdown, bitmaps.list.m)
        local ddr = Bitmap(self._dropdown, bitmaps.list.r)
        local ddll = Bitmap(self._dropdown, bitmaps.list.ll)
        local ddlm = Bitmap(self._dropdown, bitmaps.list.lm)
        local ddlr = Bitmap(self._dropdown, bitmaps.list.lr)

        -- top part is fixed under self
        LayoutHelpers.AtLeftTopIn(ddul, self._dropdown)
        LayoutHelpers.AtRightTopIn(ddur, self._dropdown)
        LayoutHelpers.AtTopIn(ddum, self._dropdown)
        ddum.Left:Set(ddul.Right)
        ddum.Right:Set(ddur.Left)

        self._list = ItemList(ddm)   -- make list depth over text so if you have them stacked, you see list
        self._list:SetFont(UIUtil.bodyFont, pointSize)
        self._list:SetColors(UIUtil.fontColor, "Black", "Black", "Gainsboro")
        if staticTitle then
            self._list:ShowSelection(false)
        end
        self._list:ShowMouseoverItem(true)

        -- middle part is fixed to width, set to height of item list
        ddl.Top:Set(ddul.Bottom)
        ddl.Left:Set(self._dropdown.Left)
        ddr.Top:Set(ddur.Bottom)
        ddr.Right:Set(self._dropdown.Right)
        ddm.Top:Set(ddum.Bottom)
        ddm.Left:Set(ddl.Right)
        ddm.Right:Set(ddr.Left)
        ddm.Height:Set(self._list.Height)
        ddl.Height:Set(self._list.Height)
        ddr.Height:Set(self._list.Height)

        -- bottom part
        ddll.Bottom:Set(self._dropdown.Bottom)
        ddll.Left:Set(self._dropdown.Left)
        ddlr.Bottom:Set(self._dropdown.Bottom)
        ddlr.Right:Set(self._dropdown.Right)
        ddlm.Bottom:Set(self._dropdown.Bottom)
        ddlm.Left:Set(ddll.Right)
        ddlm.Right:Set(ddlr.Left)

        -- list is always under the control and the width (scrollbar under button)
        self._list.Top:Set(ddm.Top)
        self._list.Left:Set(ddm.Left)
        self._list.Right:Set(ddm.Right)
        
        self._list.HandleEvent = function(control, event)
            if event.Type == 'MouseExit' then
                self:OnMouseExit()
            end
        end

        -- hide the list by default
        self._listhidden = true
        self._dropdown:Hide()
      
        -- supress show when list is in hidden state
        self._dropdown.OnHide = function(ctrl, hidden)
            if not hidden and self._listhidden then
                return true
            end

            if self:IsDisabled() then
                self._listhidden = true
                activeCombo = nil
                return
            end
            
            if not hidden then
                self._btnLeft:SetTexture(bitmaps.button.left.down)
                self._btnRight:SetTexture(bitmaps.button.right.down)
                self._btnMid:SetTexture(bitmaps.button.mid.down)
                self._text:SetColor("Black")
                self:OnMouseExit()
                if activeCombo and activeCombo != self then
                    activeCombo._listhidden = true
                    activeCombo._dropdown:SetHidden(true)
                end
                activeCombo = self
                self._dropdown.Depth:Set(self:GetRootFrame():GetTopmostDepth() + 1)
            else
                self._btnLeft:SetTexture(bitmaps.button.left.up)
                self._btnRight:SetTexture(bitmaps.button.right.up)
                self._btnMid:SetTexture(bitmaps.button.mid.up)
                self._text:SetColor(self._titleColor or UIUtil.fontColor)
                activeCombo = nil
            end
        end

        -- set the height of the list based on the number of items visible and the font metrics
        self._maxVisibleItems = maxVisibleItems
        self._visibleItems = LazyVar.Create()
        self._list.Height:Set(function() return self._visibleItems() * (self._text.FontAscent() + self._text.FontDescent() + self._text.FontExternalLeading()) end)
        self._dropdown.Height:Set(function() return self._list.Height() + ddum.Height() + ddlm.Height() end)
        self._visibleItems:Set(1)

        -- set up button logic
        self.HandleEvent = function(ctrl, event)
            local eventHandled = false

            if self:IsDisabled() then
                return eventHandled
            end

            if event.Type == 'MouseEnter' then
                if self._dropdown:IsHidden() then
                    self._btnLeft:SetTexture(bitmaps.button.left.over)
                    self._btnRight:SetTexture(bitmaps.button.right.over)
                    self._btnMid:SetTexture(bitmaps.button.mid.over)
                    self._text:SetColor(self._titleColor or UIUtil.fontColor)
                    if self.mRolloverCue then
                        local sound = Sound({Cue = self.mRolloverCue, Bank = "Interface",})
                        PlaySound(sound)
                    end
                end
                eventHandled = true
            elseif event.Type == 'MouseExit' then
                if self._dropdown:IsHidden() then
                    self._btnLeft:SetTexture(bitmaps.button.left.up)
                    self._btnRight:SetTexture(bitmaps.button.right.up)
                    self._btnMid:SetTexture(bitmaps.button.mid.up)
                    self._text:SetColor(self._titleColor or UIUtil.fontColor)
                end
                self:OnMouseExit()
                eventHandled = true
            elseif event.Type == 'ButtonPress' then
                self._listhidden = not self._dropdown:IsHidden()
                self._dropdown:SetHidden(not self._dropdown:IsHidden())
                eventHandled = true
                if self.mClickCue then
                    local sound = Sound({Cue = self.mClickCue, Bank = "Interface",})
                    PlaySound(sound)
                end
            end
            self:OnEvent(event)
                        
            return eventHandled
        end
        
        self.OnDisable = function(self)
            self._btnLeft:SetTexture(bitmaps.button.left.dis)
            self._btnRight:SetTexture(bitmaps.button.right.dis)
            self._btnMid:SetTexture(bitmaps.button.mid.dis)
            self._text:SetColor(self._titleColor or UIUtil.fontColor)
            self._dropdown:Hide()
        end
        
        self.OnEnable = function(self)
            self._btnLeft:SetTexture(bitmaps.button.left.up)
            self._btnRight:SetTexture(bitmaps.button.right.up)
            self._btnMid:SetTexture(bitmaps.button.mid.up)
            self._text:SetColor(self._titleColor or UIUtil.fontColor)
        end

        -- set up selection logic
        self._list.OnClick = function(list, row)
            ItemList.OnClick(self._list, row)
            if not self._staticTitle then self._text:SetText(self._list:GetItem(row)) end
            self:OnClick(row + 1, self._list:GetItem(row))
            self._listhidden = true
            self._dropdown:SetHidden(true)
        end

        

        self._list.OnMouseoverItem = function(list, row)
            if self.mItemCue then
                local sound = Sound({Cue = self.mItemCue, Bank = "Interface",})
                PlaySound(sound)
            end
            if row == -1 then
                self:OnOverItem(-1, nil)
            else
                self:OnOverItem(row + 1, self._list:GetItem(row))
            end
        end
        
        OnGlobalMouseClick = function(event)
            if self and self._list then
                if not self._listhidden then
                    local rightCheck
                    if self._scrollbar then
                        rightCheck = self._scrollbar.Right()
                    else
                        rightCheck = self.Right()
                    end
                    if (event.x < self.Left() or event.x > rightCheck) or (event.y < self.Top() or event.y > self._dropdown.Bottom()) then
                        self._listhidden = not self._dropdown:IsHidden()
                        self._dropdown:SetHidden(not self._dropdown:IsHidden())
                    end
                end
            end
        end
        
        UIMain.AddOnMouseClickedFunc(OnGlobalMouseClick)
        
        self.OnDestroy = function(self)
            UIMain.RemoveOnMouseClickedFunc(OnGlobalMouseClick)
        end
    end,

    -- remove old items and replace with a table of strings, also set the visible size
    -- defaultItemIndex is 1 based
    AddItems = function(self, textArray, defaultItemIndex)
        defaultItemIndex = defaultItemIndex or 1
        local numItems = table.getn(textArray)
        self._visibleItems:Set(math.min(numItems, self._maxVisibleItems))

        if self._scrollbar then
            self._scrollbar:Destroy()
        end
        if numItems > self._visibleItems() then
            self._scrollbar = UIUtil.CreateVertScrollbarFor(self._list)
        end

        for i, text in ipairs(textArray) do
            self._list:AddItem(LOC(text))
        end

        self:SetItem(defaultItemIndex)
    end,
    
    ClearItems = function(self)
        self._visibleItems:Set(0)
        self._list:DeleteAllItems()
        self._text:SetText("")
        if self._scrollbar then
            self._scrollbar:Destroy()
            self._scrollbar = nil
        end
    end,

    -- set the index selected (1 based!)
    SetItem = function(self, index)
        ItemList.OnClick(self._list, index - 1)
        if not self._staticTitle then self._text:SetText(self._list:GetItem(index - 1)) end
    end,

    -- get the index selected (1 based!) and the item
    GetItem = function(self)
        local sel = self._list:GetSelection()
        if sel >= 0 then
            return sel + 1, self._list:GetItem(sel)
        else
            return -1, nil
        end
    end,

    SetTitleText = function(self, text)
        self._text:SetText(text)
    end,
    
    SetTitleTextColor = function(self, color)
        self._titleColor = color
        self._text:SetColor(color)
    end,

    -- overload to get clicks
    OnClick = function(self, index, text)
    end,
    
    OnEvent = function(self)
    end,
    
    OnMouseExit = function(self)
    end,
    
    -- overload to get rolled over item index
    OnOverItem = function(self, index, text)
    end,
}

-- This combo is used when you have a few bitmaps you want to choose between, no scrollbar.
-- NOTE: At some point a flexible control combo that uses grid should be made so anything can be in it

-- bitmap array expects an array of bitmap names or colors
BitmapCombo = Class(Group) {
    __init = function(self, parent, bitmapArray, defaultIndex, isColor, bitmaps, rolloverCue, clickCue, debugName)
        Group.__init(self, parent)
        self:SetName(debugName or "BitmapCombo")
        
        self.mRolloverCue = rolloverCue
        self.mClickCue = clickCue

        self._bitmaps = bitmaps or defaultBitmaps

        self._btnLeft = Bitmap(self, self._bitmaps.button.left.up)
        self._btnRight = Bitmap(self, self._bitmaps.button.right.up)
        self._btnMid = Bitmap(self, self._bitmaps.button.mid.up)
        self._btnLeft:DisableHitTest()
        self._btnRight:DisableHitTest()
        self._btnMid:DisableHitTest()
        
        self.Height:Set(self._btnMid.Height)

        LayoutHelpers.AtLeftTopIn(self._btnLeft, self)
        LayoutHelpers.AtRightTopIn(self._btnRight, self)
        LayoutHelpers.AtTopIn(self._btnMid, self)
        self._btnMid.Left:Set(self._btnLeft.Right)
        self._btnMid.Right:Set(self._btnRight.Left)

        self._bitmap = Bitmap(self._btnMid)
        LayoutHelpers.AtTopIn(self._bitmap, self._btnMid, 2)
        LayoutHelpers.AtLeftIn(self._bitmap, self._btnLeft, 5)
        self._bitmap:DisableHitTest()

        self._dropdown = Group(self)
        LayoutHelpers.DepthOverParent(self._dropdown, self._bitmap, 1)
        self._dropdown:Hide()
    
        self._dropdown.HandleEvent = function(control, event)
            if event.Type == 'MouseExit' then
                self:OnMouseExit()
            end
        end
        
        self:ChangeBitmapArray(bitmapArray,isColor)

        self:SetItem(defaultIndex)
        self._curIndex = defaultIndex

        -- supress show when list is in hidden state
        self._dropdown.OnHide = function(ctrl, hidden)
            if not hidden and self._ddhidden then
                return true
            end

            if self:IsDisabled() then
                self._ddhidden = true
                activeCombo = nil
                return
            end

            if not hidden then
                self._btnLeft:SetTexture(self._bitmaps.button.left.down)
                self._btnRight:SetTexture(self._bitmaps.button.right.down)
                self._btnMid:SetTexture(self._bitmaps.button.mid.down)
                if activeCombo and activeCombo != self then
                    activeCombo._ddhidden = true
                    activeCombo._dropdown:SetHidden(true)
                end
                activeCombo = self
            else
                self._btnLeft:SetTexture(self._bitmaps.button.left.up)
                self._btnRight:SetTexture(self._bitmaps.button.right.up)
                self._btnMid:SetTexture(self._bitmaps.button.mid.up)
                activeCombo = nil
            end
        end

        -- set up control logic
        self.HandleEvent = function(ctrl, event)
            local eventHandled = false

            if self:IsDisabled() then
                return
            end

            if event.Type == 'MouseEnter' then
                if self._dropdown:IsHidden() then
                    self._btnLeft:SetTexture(self._bitmaps.button.left.over)
                    self._btnRight:SetTexture(self._bitmaps.button.right.over)
                    self._btnMid:SetTexture(self._bitmaps.button.mid.over)
                    if self.mRolloverCue then
                        local sound = Sound({Cue = self.mRolloverCue, Bank = "Interface",})
                        PlaySound(sound)
                    end
                end
                eventHandled = true
            elseif event.Type == 'MouseExit' then
                if self._dropdown:IsHidden() then
                    self._btnLeft:SetTexture(self._bitmaps.button.left.up)
                    self._btnRight:SetTexture(self._bitmaps.button.right.up)
                    self._btnMid:SetTexture(self._bitmaps.button.mid.up)
                end
                eventHandled = true
            elseif event.Type == 'ButtonPress' then
                self._ddhidden = not self._dropdown:IsHidden()
                self._dropdown:SetHidden(not self._dropdown:IsHidden())
                eventHandled = true
                if self.mClickCue then
                    local sound = Sound({Cue = self.mClickCue, Bank = "Interface",})
                    PlaySound(sound)
                end
            end
            self:OnEvent(event)
                        
            return eventHandled
        end

        self.OnDisable = function(self)
            self._btnLeft:SetTexture(self._bitmaps.button.left.dis)
            self._btnRight:SetTexture(self._bitmaps.button.right.dis)
            self._btnMid:SetTexture(self._bitmaps.button.mid.dis)
            self._dropdown:Hide()
        end
        
        self.OnEnable = function(self)
            self._btnLeft:SetTexture(self._bitmaps.button.left.up)
            self._btnRight:SetTexture(self._bitmaps.button.right.up)
            self._btnMid:SetTexture(self._bitmaps.button.mid.up)
        end
        
        OnGlobalMouseClick = function(event)
            if self and self._dropdown then
                if not self._ddhidden then
                    if (event.x < self.Left() or event.x > self.Right()) or (event.y < self.Top() or event.y > self._dropdown.Bottom()) then
                        self._ddhidden = not self._dropdown:IsHidden()
                        self._dropdown:SetHidden(not self._dropdown:IsHidden())
                    end
                end
            end
        end
        
        UIMain.AddOnMouseClickedFunc(OnGlobalMouseClick)
        
        self.OnDestroy = function(self)
            UIMain.RemoveOnMouseClickedFunc(OnGlobalMouseClick)
        end
    end,

    # Nuke the old bitmap array and replace it
    ChangeBitmapArray = function( self, bitmapArray, isColor )

        self._array = bitmapArray
        self._isColor = isColor

        if self._list then
            for k,v in self._list do
                v:Destroy()
            end
        end

        self._list = {}
        self._listbmp = {}
        self._listhilight = {}
        
        local prev = nil
        for index, bmp in bitmapArray do
            self._list[index] = Group(self._dropdown)
            self._listbmp[index] = Bitmap(self._list[index])
            self._listbmp[index]:DisableHitTest()
            LayoutHelpers.DepthOverParent(self._listbmp[index], self._list[index], 2)   -- make room for highlight underneath
            self._list[index].Width:Set(self._dropdown.Width)
            local listIndex = index
            self._list[index].Height:Set(function() return self._listbmp[listIndex].Height() + LayoutHelpers.ScaleNumber(4) end)
            self:SetBitmap(self._listbmp[index], bmp)
            LayoutHelpers.AtLeftTopIn(self._listbmp[index], self._list[index], 2, 2)
            local prevCtrl = prev   -- this gets the prev control into the closure of this iteration
            if index == 1 then
                LayoutHelpers.AtLeftTopIn(self._list[index], self._dropdown)
            else
                LayoutHelpers.Below(self._list[index], prevCtrl, 1)
            end
            
            self._list[index]._index = index
            self._list[index].HandleEvent = function(ctrl, event)
                local eventHandled = false
                if event.Type == 'MouseEnter' then
                    if not ctrl.highlight then
                        ctrl.highlight = Bitmap(ctrl, UIUtil.SkinnableFile('/widgets/drop-down/player-text-highlight_bmp.dds'))
                        LayoutHelpers.FillParent(ctrl.highlight, ctrl)
                        ctrl.highlight:DisableHitTest()
                        self:OnOverItem(ctrl._index, self._array[ctrl._index])
                        eventHandled = true
                    end
                elseif event.Type == 'MouseExit' then
                    if ctrl.highlight then 
                        ctrl.highlight:Destroy()
                        ctrl.highlight = nil
                        eventHandled = true
                    end
                elseif event.Type == 'ButtonPress' or event.Type == 'ButtonDClick' then
                    self:SetItem(ctrl._index)
                    self._ddhidden = true
                    self._dropdown:SetHidden(true)
                    self:OnClick(ctrl._index, self._array[ctrl._index])
                    eventHandled = true
                end
                return eventHandled
            end
            prev = self._list[index]
        end

        -- prev will be last control here
        local ddul = Bitmap(self._dropdown, self._bitmaps.list.ul)
        local ddum = Bitmap(self._dropdown, self._bitmaps.list.um)
        local ddur = Bitmap(self._dropdown, self._bitmaps.list.ur)
        local ddl = Bitmap(self._dropdown, self._bitmaps.list.l)
        local ddm = Bitmap(self._dropdown)
        ddm:SetSolidColor("black")
        local ddr = Bitmap(self._dropdown, self._bitmaps.list.r)
        local ddll = Bitmap(self._dropdown, self._bitmaps.list.ll)
        local ddlm = Bitmap(self._dropdown, self._bitmaps.list.lm)
        local ddlr = Bitmap(self._dropdown, self._bitmaps.list.lr)

        -- top part is fixed under self
        LayoutHelpers.AnchorToBottom(ddul, self._btnMid)
        LayoutHelpers.AtLeftIn(ddul, self._btnLeft, 5)
        LayoutHelpers.AnchorToBottom(ddur, self._btnMid)
        LayoutHelpers.AtRightIn(ddur, self._btnRight)
        LayoutHelpers.AnchorToBottom(ddum, self._btnMid)
        LayoutHelpers.AnchorToRight(ddum, ddul)
        LayoutHelpers.AnchorToLeft(ddum, ddur)

        -- middle part is fixed to width, set to height of item list
        ddl.Top:Set(ddul.Bottom)
        ddl.Left:Set(ddul.Left)
        ddr.Top:Set(ddur.Bottom)
        ddr.Right:Set(ddur.Right)
        ddm.Top:Set(ddum.Bottom)
        ddm.Left:Set(ddl.Right)
        ddm.Right:Set(ddr.Left)
        ddm.Bottom:Set(prev.Bottom)
        LayoutHelpers.ResetHeight(ddm)
        ddl.Height:Set(ddm.Height)
        ddr.Height:Set(ddm.Height)

        -- bottom part
        LayoutHelpers.AnchorToBottom(ddll, ddl)
        LayoutHelpers.AtLeftIn(ddll, ddl)
        LayoutHelpers.AnchorToBottom(ddlr, ddr)
        LayoutHelpers.AtRightIn(ddlr, ddr)
        LayoutHelpers.AnchorToBottom(ddlm, ddm)
        LayoutHelpers.AnchorToRight(ddlm, ddl)
        LayoutHelpers.AnchorToLeft(ddlm, ddr)

        LayoutHelpers.FillParent(self._dropdown, ddm)
        self._dropdown:Hide()
        self._ddhidden = true
    end,

    SetBitmap = function(self, bmp, name)
        if self._isColor then
            bmp:SetSolidColor(name)
        else
            bmp:SetTexture(UIUtil.SkinnableFile(name))
        end
        bmp.Width:Set(function() return self._btnMid.Width() + self._btnLeft.Width() - LayoutHelpers.ScaleNumber(5) end)
        bmp.Height:Set(function() return self._btnMid.Height() - LayoutHelpers.ScaleNumber(4) end)
    end,

    -- set the index selected
    SetItem = function(self, index)
        self:SetBitmap(self._bitmap, self._array[index])
        self._curIndex = index
    end,

    GetItem = function(self)
        return self._curIndex
    end,

    OnEvent = function(self)
    end,
    -- overload to get the selection
    OnClick = function(self, index, name)
    end,

    OnMouseExit = function(self)
    end,
    
    -- overload to get rolled over item index
    OnOverItem = function(self, index, name)
    end,

}

