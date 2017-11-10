//===============================================================================
//     REVISION:  $Id$
//  DESCRIPTION:  Add word to the list of known words
//       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
//===============================================================================

function addToKnownWords(wordNumber) {
    var xmlhttp;

    if (window.XMLHttpRequest)  { // IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    }
    else { // IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var result = xmlhttp.responseText;
            var div    = document.getElementById("add_to_known_words_button");
            if (result == "ok") {
                div.innerHTML='<span class="message">Добавили!<span>';
            }
            else if (result == "duplicate" ){
                div.innerHTML='<span class="warning">Ой! Это слово уже добавлено<span>';
            }
            else {
                div.innerHTML='<span class="error">Ой! Ошибка при добавлении слова<span>';
            }
        }

        return true;
    }

    xmlhttp.open("POST", "/lesson/add_to_known_words/" + wordNumber, true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send();

    return true;
}
