// ==UserScript==
// @name        Cubari Chapter Redirect
// @namespace   Userscripts
// @match       https://mangadex.org/chapter/*
// @grant       GM_xmlhttpRequest
// @version     0.1.1
// @author      danke
// @description Redirect from MangaDex chapter links to Cubari
// @downloadURL https://github.com/JodanJodan/MangaToolsnke/raw/main/cubanke.user.js
// ==/UserScript==

const API_BASE_URL = "https://api.mangadex.org"
const CUB_BASE_URL = "https://cubari.moe"

document.body.innerHTML = "";
GM_xmlhttpRequest({
  method: "GET",
  url: `${API_BASE_URL}${window.location.pathname}`,
  responseType: "json",
  onload: function(responseDetails) {
    data = JSON.parse(responseDetails.responseText)["data"];
    [chapterNum, seriesId, groupId] = [data["attributes"]["chapter"],
                                       data["relationships"].find(e => e["type"] === "manga")["id"],
                                       data["relationships"].find(e => e["type"] === "scanlation_group")["id"]];
    GM_xmlhttpRequest({
      method: "GET",
      url: `${API_BASE_URL}/chapter?manga=${seriesId}&chapter=${chapterNum}&limit=100`,
      responseType: "json",
      onload: function(responseDetails) {
        data = JSON.parse(responseDetails.responseText)["data"];
        // Currently grabs wrong group number most of the time; need to update to match Cubari's numbering.
        groupNum = Number(data
                          .filter(e => e["attributes"]["translatedLanguage"] === "en")
                          .findIndex(e => e["relationships"][0]["id"] === groupId)
                         );
        window.location.replace(`${CUB_BASE_URL}/read/mangadex/${seriesId}/${chapterNum}/#${groupNum}`);
      }
    });
  }
});
