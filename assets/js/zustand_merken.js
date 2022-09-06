// ÜBERSICHTSLISTEN: ZUSTAND MERKEN BEI SEITENWECHSEL

// Ausführen der Funktion, sobald die Seite dazu bereit ist
$(document).ready(function () {
    // Speichern des Listenelements über seine ID mit dem Wert "true" im localStorage des Browsers, sobald es ausgeklappt wird
    $(".collapse").on("shown.bs.collapse", function(e) {
        if ($(this).is(e.target)) {
            localStorage.setItem(this.id, true);
        }
    });
    // Entfernen des Listenelements über seine ID aus dem localStorage des Browsers, sobald es eingeklappt wird
    $(".collapse").on("hidden.bs.collapse", function(e) {
        // Dabei: Überprüfen, dass es sich nur um das Zielelement handelt -> Ansonsten werden auch alle übergeordneten (noch ausgeklappten) Elemente aus dem localStorage entfernt
        if ($(this).is(e.target)) {
            localStorage.removeItem(this.id);
        }
    });
    // Überprüfen für jedes Listenelement, ob seine ID im LocalStorage des Browsers vorhanden bzw. "true" ist
    $(".collapse").each(function () {
        if (localStorage.getItem(this.id) == "true") {
            // Falls ja: Element wird ausgeklappt und sein Chevron-Icon mit der "active"-Klasse versehen (für Rotation und Farbwechsel -> Siehe svg_icons.scss-Datei im _sass-Ordner)
            $(this).collapse("show");
            $(this).prevAll("a.chevron_link:first").find(".rotate_180").addClass("active");
        }
    });
});