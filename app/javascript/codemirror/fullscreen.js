// CodeMirror, copyright (c) by Marijn Haverbeke and others
// Distributed under an MIT license: https://codemirror.net/5/LICENSE

(function(mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
    mod(require("../../lib/codemirror"));
  else if (typeof define == "function" && define.amd) // AMD
    define(["../../lib/codemirror"], mod);
  else // Plain browser env
    mod(CodeMirror);
})(function(CodeMirror) {
  "use strict";

  CodeMirror.defineOption("fullScreen", false, function(cm, val, old) {
    if (old == CodeMirror.Init) {
      old = false;
      setFullscreenButton(cm);
    }
    if (!old == !val) return;
    if (val) setFullscreen(cm);
    else setNormal(cm);
  });

  function setFullscreenButton(cm) {
    var wrap     = cm.getWrapperElement();
    var fsButton = document.createElement('a');

    fsButton.className = "CodeMirror-fsbutton CodeMirror-fsbutton-expand";

    wrap.appendChild(fsButton);
    cm.refresh();
  }

  function setFullscreen(cm) {
    var wrap     = cm.getWrapperElement();
    var fsButton = document.getElementsByClassName("CodeMirror-fsbutton")[0];
    cm.state.fullScreenRestore = {scrollTop: window.pageYOffset, scrollLeft: window.pageXOffset,
                                  width: wrap.style.width, height: wrap.style.height};
    wrap.style.width = "";
    wrap.style.height = "auto";
    wrap.className += " CodeMirror-fullscreen";

    fsButton.className = fsButton.className.replace(/\s*CodeMirror-fsbutton-expand\b/, "");
    fsButton.className += " CodeMirror-fsbutton-compress";

    document.documentElement.style.overflow = "hidden";
    cm.refresh();
  }

  function setNormal(cm) {
    var wrap = cm.getWrapperElement();
    var fsButton = document.getElementsByClassName("CodeMirror-fsbutton")[0];

    wrap.className = wrap.className.replace(/\s*CodeMirror-fullscreen\b/, "");

    fsButton.className = fsButton.className.replace(/\s*CodeMirror-fsbutton-compress\b/, "");
    fsButton.className += " CodeMirror-fsbutton-expand";

    document.documentElement.style.overflow = "";
    var info = cm.state.fullScreenRestore;
    wrap.style.width = info.width; wrap.style.height = info.height;
    window.scrollTo(info.scrollLeft, info.scrollTop);
    cm.refresh();
  }
});
