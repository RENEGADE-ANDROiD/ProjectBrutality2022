class PB_ListMenu : ListMenu 
{
    PBTK_UIController controller;
    array<PBTK_Button> buttons;
    int btnSelection;
    int mouseX, mouseY;

    TextureID pblogo, dtlogo, menuCursor;

    override void Init(Menu parent, ListMenuDescriptor desc)
	{
        Super.Init(parent, desc);

        mParentMenu = parent;
		mMouseCapture = true;
		SetMouseCapture(true);
		mBackbuttonSelected = false;
		DontDim = true;
		DontBlur = false;
		AnimatedTransition = false;
		Animated = true;

        mDesc = desc;
        controller = PBTK_UIController.Create(PBTK_SCREEN_BOTTOM_CENTER);
        if (!controller)
            return;
        controller.glbStartPos = (0, -50);
        PBTK_Button leButton;

        pblogo = TexMan.CheckForTexture("M_DOOMPB", TexMan.Type_Any);
        if(!pblogo.isValid())
            pblogo = TexMan.CheckForTexture("HIRES/M_DOOMPB.png", TexMan.Type_Any);

        menuCursor = TexMan.CheckForTexture("doomcurs", TexMan.Type_Any);
        if (!menuCursor.isValid())
            menuCursor = TexMan.CheckForTexture("M_SKULL1", TexMan.Type_Any);

        mouseX = Screen.GetWidth() / 2;
        mouseY = Screen.GetHeight() / 2;

        S_StartSound("menu/whoosh", 0, CHANF_UI, pitch: cfrandom(0.8, 0.9));

		for(int i = 0; i < mDesc.mItems.Size(); i++)
        {
            ListMenuItem item = mDesc.mItems[i];
            if(!item) continue;

            if(item is 'ListMenuItemTextItem')
            {
                let textitem = ListMenuItemTextItem(item);
                leButton = PBTK_Button.InitButton(
                    (0, 0), 
                    cft("graphics/menu/button_inactive.png"), 
                    cft("graphics/menu/button_active.png"), 
                    cft("graphics/menu/button_hovered.png"), 
                    cft("graphics/menu/button_clicked.png"),
                    controller,
                    textitem.mText,
                    i,
                    mDesc
                );
                if (!leButton)
                    continue;
                leButton.btnAlpha = 0;
                leButton.goalPos = (0, 0);
                leButton.myItem = item;
                buttons.Push(leButton);

                if(CheckFocus(item))
                    btnSelection = buttons.Size() - 1;
            }
        }

        if (btnSelection < 0 && buttons.Size() > 0)
            btnSelection = 0;
        SyncDescSelectedItem(btnSelection);
	}

    void SyncDescSelectedItem(int buttonIndex)
    {
        if (!mDesc || buttonIndex < 0 || buttonIndex >= buttons.Size())
            return;
        let btn = buttons[buttonIndex];
        if (!btn)
            return;
        if (btn.descItemIndex >= 0 && btn.descItemIndex < mDesc.mItems.Size())
            mDesc.mSelectedItem = btn.descItemIndex;
    }

    int HitTestButtons(int mx, int my)
    {
        if (!controller || !mDesc || buttons.Size() < 1)
            return -1;

        int n = buttons.Size();
        int rowH = max(int(Screen.GetHeight() * 0.065), 36);
        int anchorY = int(Screen.GetHeight() * (490.0 / 540.0));
        int centerX = Screen.GetWidth() / 2;
        int halfW = int(Screen.GetWidth() * 0.42);

        // Topmost item first (i=0 is drawn highest on screen).
        for (int i = 0; i < n; i++)
        {
            if (!buttons[i])
                continue;

            int buttonPosition = (n - 1) - i;
            int hl, ht, hr, hb;
            buttons[i].GetScreenHitRect(mDesc, buttonPosition, hl, ht, hr, hb);

            if (hr <= hl || hb <= ht)
            {
                ht = anchorY - buttonPosition * rowH;
                hb = ht + rowH;
                hl = centerX - halfW;
                hr = centerX + halfW;
            }

            if (mx >= hl && mx <= hr && my >= ht && my <= hb)
                return i;
        }
        return -1;
    }

    bool ActivateSelection()
    {
        if (!controller || !mDesc)
            return false;
        if (btnSelection < 0 || btnSelection >= buttons.Size())
            return false;
        let btn = buttons[btnSelection];
        if (!btn || !btn.myItem || !btn.myItem.Selectable())
            return false;
        if (controller.transitioning != PBTK_UIController.TR_NONE)
            return true;
        SyncDescSelectedItem(btnSelection);
        controller.transitioning = PBTK_UIController.TR_GOFORWARD;
        btn.clicked = 1;
        controller.transitionTicks = 8;
        MenuSound("menu/activate");
        S_StartSound("RAIL_ZM", 0, CHANF_UI, pitch: 0.8);
        return true;
    }
    
    override void Ticker()
    {
        if (!controller)
            return;

        controller.ControllerTick();

        switch(controller.transitioning)
        {
            case PBTK_UIController.TR_GOBACK:
                if(controller.transitionTicks <= 0)
                {
                    Close();
                    return;
                }
                break;
        }

        for(int i = 0; i < buttons.Size(); i++)
        {
            if (buttons[i])
                buttons[i].UpdateAnimations();
        }
    }

    void DrawStaticMenuItems()
    {
        if (!mDesc)
            return;

        for (int i = 0; i < mDesc.mItems.Size(); i++)
        {
            let item = mDesc.mItems[i];
            if (!item || !item.mEnabled)
                continue;
            if (item is 'ListMenuItemTextItem')
                continue;
            item.Draw(mDesc.mSelectedItem == i, mDesc);
        }
    }

    override void Drawer()
    {
        if (!controller)
            return;

        DrawStaticMenuItems();

        if (pblogo.isValid())
        {
            // 33% smaller than prior 3.9 scale (~2.61).
            double logoScale = 2.61;
            PBTK_StatusBarScreen.DrawTexture(pblogo, (0, 122), PBTK_SCREEN_TOP_CENTER, scale: (logoScale, logoScale));
        }

        for(int i = 0; i < buttons.Size(); i++)
        {
            if (!buttons[i])
                continue;
            bool selected = (i == btnSelection);
            int buttonPosition = (buttons.Size() - 1) - i;
            buttons[i].Draw(selected, mDesc, buttonPosition);
        }

        if (menuCursor.isValid())
        {
            Screen.DrawTexture(menuCursor, true, mouseX, mouseY,
                DTA_CleanNoMove, true,
                DTA_LeftOffset, 0,
                DTA_TopOffset, 0);
        }
    }

    TextureID cft(string tex)
    {
        return TexMan.CheckForTexture(tex);
    }

    override bool MouseEvent(int type, int x, int y)
    {
        if (!controller)
            return false;

        mouseX = x;
        mouseY = y;

        if (controller.transitioning != PBTK_UIController.TR_NONE)
            return true;

        int hit = HitTestButtons(x, y);
        if (hit >= 0 && hit != btnSelection)
        {
            btnSelection = hit;
            SyncDescSelectedItem(btnSelection);
            MenuSound("menu/cursor");
        }

        if (type == Menu.MOUSE_Release)
        {
            if (hit >= 0)
            {
                btnSelection = hit;
                SyncDescSelectedItem(btnSelection);
                return ActivateSelection();
            }
            return true;
        }

        return true;
    }

    override bool MenuEvent(int mkey, bool fromcontroller)
	{
        if(controller.transitioning != PBTK_UIController.TR_NONE) {
            if(mkey == MKEY_Back && controller.transitioning == PBTK_UIController.TR_GOFORWARD) {
                controller.transitioning = PBTK_UIController.TR_NONE;
                controller.transitionTicks = 0;
            }
            return true;
        }
        
		switch (mkey)
		{
            case MKEY_Up:
                btnSelection--;
                if(btnSelection < 0) btnSelection = buttons.Size() - 1;
                SyncDescSelectedItem(btnSelection);
                MenuSound("menu/cursor");
                return true;
            case MKEY_Down:
                btnSelection++;
                if(btnSelection > buttons.Size() - 1) btnSelection = 0;
                SyncDescSelectedItem(btnSelection);
                MenuSound("menu/cursor");
                return true;
            case MKEY_Enter:
                return ActivateSelection();
            case MKEY_Back:
                if(btnSelection >= 0 && btnSelection <= buttons.Size()-1) 
                {
                    controller.transitioning = PBTK_UIController.TR_GOBACK;
                    buttons[btnSelection].clicked = 0;
                    controller.transitionTicks = 8;
                    MenuSound(mParentMenu ? "menu/backup" : "menu/clear");
                    S_StartSound("RAIL_UZ", 0, CHANF_UI, pitch: 0.8);
                }
                return true;
            default:
                return false;
		}
		return false;
	}
}

class PB_TitleLogoHandler : EventHandler
{
    TextureID pblogo, dtlogo;

    override void WorldLoaded(WorldEvent e)
    {
        pblogo = TexMan.CheckForTexture("M_DOOMPB", TexMan.Type_Any);
        if (!pblogo.isValid())
            pblogo = TexMan.CheckForTexture("HIRES/M_DOOMPB.png", TexMan.Type_Any);
        dtlogo = TexMan.CheckForTexture("graphics/menu/pb_devteam_logo.png");
    }

    override void RenderOverlay(RenderEvent e)
    {
        if(gamestate != GS_TITLELEVEL) return;

        PBTK_StatusBarScreen.DrawTexture(pblogo, (0, 120), PBTK_SCREEN_TOP_CENTER, scale: (2.61, 2.61));
        PBTK_StatusBarScreen.DrawTexture(dtlogo, (-50, -50), PBTK_SCREEN_BOTTOM_RIGHT, scale: (0.25, 0.25));
    }
}
