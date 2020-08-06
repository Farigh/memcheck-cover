/****
 * Memcheck-cover is an HTML report generator on top of valgrind's memcheck
 * Copyright (C) 2020  GARCIN David <https://github.com/Farigh/memcheck-cover>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * This function toggles the visibility of the analysis content
 *
 * @param test_id: The analysis report unique ID
 */
function ToggleAnalysisResultVisibility(test_id)
{
    UpdateAnalysisVisibility('toggle', test_id);
}

/**
 * This function sets the current analysis displayed title
 */
function SetAnalysisTitle(title_id)
{
    document.documentElement.setAttribute('data-title-type', title_id);
    localStorage.setItem('title_type', title_id);
}

/**
 * This function sets the current analysis CSS theme
 */
function SetCssTheme(theme_id)
{
    document.documentElement.setAttribute('data-theme', theme_id);
    localStorage.setItem('theme', theme_id);
}

/**
 * This function processes all results and expands any being hidden
 */
function ExpandAll()
{
    UpdateAllAnalysisVisibility('expand');
}

/**
 * This function processes all results and collapses any being displayed
 */
function CollapseAll()
{
    UpdateAllAnalysisVisibility('collapse');
}

/**
 * This function processes all results and applies the specified action
 *
 * @param action: Visibility type to apply, could have the following value:
 *    - collapse: Hides the displayed results
 *    - expand: Displays the hidden results
 */
function UpdateAllAnalysisVisibility(action)
{
    var id_num = 1;
    // Iterate over all results
    while (true)
    {
        var test_id = "valgrind.result" + id_num.toString();
        var visibility_span = document.getElementById(test_id + ".VisibilityIcon");

        if (visibility_span == null)
        {
            break;
        }

        ++id_num;

        UpdateAnalysisVisibility(action, test_id);
    }
}

/**
 * This function applies the specified action to the selected test result
 *
 * @param action: Visibility action to perform, could have the following value:
 *    - collapse: Hides the selected test result if visible
 *    - expand: Displays the selected test result if hidden
 *    - toggle: Toggles the visibility of the selected test
 * @param test_id: The analysis report unique ID
 */
function UpdateAnalysisVisibility(action, test_id)
{
    var visibility_span = document.getElementById(test_id + ".VisibilityIcon");
    var analysis_div = document.getElementById(test_id + ".Report");

    if (analysis_div.className === "memcheck_analysis_content")
    {
        if (action == "toggle" || action == "collapse")
        {
            // Update the visibility image to the expand one
            visibility_span.innerHTML = "<div class=\"expand\"><div></div></div>";

            // Add the hidden class to the analysis content
            analysis_div.className = "memcheck_analysis_content hidden";
        }
    }
    else
    {
        if (action == "toggle" || action == "expand")
        {
            // Update the visibility image to the collapse one
            visibility_span.innerHTML = "<div class=\"collapse\"><div></div></div>";

            // Remove the hidden class to the analysis content
            analysis_div.className = "memcheck_analysis_content";
        }
    }
}

/**
 * This function toggles the visibility of the violation suppression content
 *
 * @param titleDiv: The violation suppression "button" div that triggered the event
 */
function ToogleSuppressionVisibility(titleDiv)
{
    // Next siblig is a <br /> tag, the second next is the content
    contentDiv = titleDiv.nextSibling.nextSibling;

    actionToPerform = "";
    visibilityClass = "";

    if (contentDiv.className === "suppression_content")
    {
        actionToPerform = "Show";

        // Update the visibility image to the expand one
        visibilityClass = "expand";

        // Add the hidden class to the suppression content
        contentDiv.className = "suppression_content hidden";
    }
    else
    {
        actionToPerform = "Hide";

        // Update the visibility image to the collapse one
        visibilityClass = "collapse";

        // Remove the hidden class to the suppression content
        contentDiv.className = "suppression_content";
    }

    titleDiv.innerHTML = "<span class=\"suppression_visibility_icon\"><div class=\""
                       + visibilityClass + "\"><div></div></div></span> "
                       + actionToPerform + " generated suppression";
}

/**
 * This function restores previously stored settings.
 * The following display settings are stored:
 *   - The CSS theme (Light or Dark)
 *   - The analysis title type (Command or Analysis name)
 */
function initializePage()
{
    // Restore previously set theme
    var storedTheme = localStorage.getItem('theme');

    if (storedTheme != null)
    {
        document.documentElement.setAttribute('data-theme', storedTheme);
    }

    // Restore previously set title type
    var storedTitle = localStorage.getItem('title_type');

    if (storedTitle != null)
    {
        document.documentElement.setAttribute('data-title-type', storedTitle);
    }

}

// Reload saved properties
initializePage();
