angular.module('bitcampApp').run(['$templateCache', function($templateCache) {
  'use strict';

  $templateCache.put('layout/404/index.html',
    "<div id=\"fourOhFour\" ng-show=\"isLoaded\"><header id=\"header\" class=\"row btc-row\"><div ng-include=\"\" onload=\"isLoaded = true\" src=\"'layout/header-logo-notenttree.html'\"></div><div class=\"col-xs-12\"><div class=\"vspace\"></div><h2>Are you lost?</h2><h3>You should <a href=\"/\">head back</a> to the campsite.</h3></div></header></div>"
  );


  $templateCache.put('layout/footer.html',
    "<footer id=\"footer\" ng-cloak=\"ng-cloak\" class=\"row btc-row\"><div id=\"footer-inner\"><div id=\"footer-content\" class=\"p\"><div class=\"col-xs-12\"><a href=\"mailto:hello@bit.camp\" target=\"_blank\">Email</a>&ensp;·&ensp;<a href=\"https://twitter.com/bitcmp\" target=\"_blank\">Twitter</a>&ensp;·&ensp;<a href=\"https://www.facebook.com/bitcmp\" target=\"_blank\">Facebook</a>&ensp;·&ensp;<a href=\"https://medium.com/bitcampfire-stories\" target=\"_blank\">Medium</a></div></div></div></footer>"
  );


  $templateCache.put('layout/header-logo-colorwar.html',
    "<div id=\"logo\" class=\"col-xs-12 noselect\"><a ui-sref=\"main\" class=\"noselect\"><img src=\"/images/logo-colorwar.svg\" width=\"187\" height=\"200\"></a></div><sdss></sdss>"
  );


  $templateCache.put('layout/header-logo-notenttree.html',
    "<div id=\"logo\" class=\"col-xs-12 noselect\"><a ui-sref=\"main\" class=\"noselect\"><img src=\"/images/logo.svg\" width=\"187\" height=\"200\"></a></div>"
  );


  $templateCache.put('layout/header-logo.html',
    "<div class=\"btc-background-wrapper\"><div ng-if=\"!twinkle\" class=\"btc-background\"><div ng-repeat=\"star in stars1\" ng-style=\"{'left': star.x+'%', 'top': star.y+'%'}\" class=\"star\"></div><div id=\"treetent\"><div id=\"treetent-img\"><img analyics-on=\"click\" analytics-category=\"easter-egg\" analytics-label=\"twinkle\" scroll-to=\"#wrapper\" src=\"/images/treetent.svg\" width=\"100\" height=\"100\" ng-click=\"treetentClick()\"/></div></div></div><div ng-if=\"twinkle\" class=\"btc-background\"><div ng-repeat=\"star in stars2\" id=\"star-{{$index}}\" ng-style=\"{'left': star.x+'%', 'top': star.y+'%'}\" class=\"star twinkle\"></div><div id=\"treetent\"><div id=\"treetent-img\"><img scroll-to=\"#wrapper\" src=\"/images/treetent.svg\" width=\"100\" height=\"100\" ng-click=\"treetentClick()\"/></div></div></div></div><div id=\"logo\" class=\"col-xs-12 noselect\"><a ui-sref=\"main\" class=\"noselect\"><img src=\"/images/logo.svg\" height=\"150\"></a></div>"
  );


  $templateCache.put('main/index.html',
    "<div id=\"main\" ng-show=\"isLoaded\" ng-class=\"{'fullscreen': twinkle}\"><header id=\"header\" class=\"btc-row\"><div ng-include=\"\" src=\"'layout/header-logo.html'\" onload=\"isLoaded = true\" class=\"header-logo\"></div><div class=\"flexbox\"><div class=\"flex\"><div id=\"title\" ng-if=\"!twinkle\" class=\"h1\">Lights Out</div></div><div class=\"flex\"><div id=\"subtitle\" ng-if=\"!twinkle\" class=\"p\">Ready for s'more hacks? Bitcamp 2015 coming soon.</div></div><div class=\"flex\"><div id=\"old-site\" ng-if=\"!twinkle\" class=\"h3\"><a href=\"http://2014.bit.camp/\" target=\"_blank\"><button>2014 website</button></a></div></div></div></header><div id=\"updates\" class=\"btc-row\"><div id=\"updates-input\"><h2>{{successText || 'get email updates'}}</h2><h3><form id=\"signup\" name=\"signup\" ng-submit=\"submit()\" ng-class=\"{'shake': signupError, 'tada': signupSuccess}\" class=\"animated\"><input type=\"text\" autocapitalize=\"off\" autocorrect=\"off\" spellcheck=\"false\" ng-model=\"signup.name\" placeholder=\"name\" ng-disabled=\"successText\"/><input type=\"text\" autocapitalize=\"off\" autocorrect=\"off\" spellcheck=\"false\" ng-model=\"signup.email\" placeholder=\"email\" ng-disabled=\"successText\"/><input type=\"text\" autocapitalize=\"off\" autocorrect=\"off\" spellcheck=\"false\" ng-model=\"signup.university\" placeholder=\"school\" ng-disabled=\"successText\" class=\"animated\"/><input type=\"submit\" style=\"position: absolute; left: -9999px; width: 1px; height: 1px; visibility: hidden;\"/></form></h3></div></div></div>"
  );

}]);
