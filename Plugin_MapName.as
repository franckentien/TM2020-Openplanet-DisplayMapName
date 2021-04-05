#name "Display Map Name"
#author "Franckentien"
#category "Utilities"
#version "1.0"
#siteid 89
#include "Icons.as"
#include "Formatting.as"

[Setting name="Show Map name"]
bool displayName = true;

[Setting name="Anchor X position" min=0 max=1]
float anchorX = .95;

[Setting name="Anchor Y position" min=0 max=1]
float anchorY = .95;

[Setting name="Font size" min=8 max=72]
int fontSize = 24;

bool inGame = false;

string mapName = "";
string authorName = "";
string displayText = "";

void RenderMenu() {
  if (UI::MenuItem("\\$09f" + Icons::ListAlt + "\\$z Display Map Name", "", displayName)) {
    displayName = !displayName;
  }
}

void Render() {
  if(displayName && inGame) {
    nvg::FontSize(fontSize);
    nvg::TextAlign(nvg::Align::Center | nvg::Align::Right);
    nvg::TextBox(anchorX * Draw::GetWidth() - 210, anchorY * Draw::GetHeight(), 300, displayText);
    nvg::Reset();
  }
}

void Update(float dt) {

  if(cast<CSmArenaClient>(GetApp().CurrentPlayground) !is null) {
    CSmArenaClient@ playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);
    if(playground.GameTerminals.Length <= 0
       || playground.GameTerminals[0].UISequence_Current != ESGamePlaygroundUIConfig__EUISequence::Playing
       || cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer) is null
       || playground.Arena is null
       || playground.Map is null) {
      inGame = false;
      return;
    }
    CSmPlayer@ player = cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
    MwFastBuffer<CGameScriptMapLandmark@> landmarks = playground.Arena.MapLandmarks;
    
    inGame = true;

    mapName = playground.Map.MapName;
    authorName = playground.Map.AuthorNickName;


    displayText = StripFormatCodes(mapName) + "\n" + StripFormatCodes(authorName) ;   

    } 
    else {
        inGame = false;
        return;
    }
}
