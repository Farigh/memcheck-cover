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
 * This function processes all results and toggles the displayed title
 * between 'Analysis name' and 'Execution command'
 */
function ToggleAnalysisTitleType()
{
    var id_num = 1;

    var toggle_to_title = "unset";

    var current_button = document.getElementById("analysis_title_type_button");

    // Disable button action to prevent multiple click before all results title are updated
    var old_onclick_action = current_button.onclick;
    current_button.onclick = "";

    // Update button description
    var toggle_to_title_content = "Toggle title: Analysis name";
    if (current_button.innerHTML == toggle_to_title_content)
    {
        current_button.innerHTML = "Toggle title: Command";
    }
    else
    {
        current_button.innerHTML = toggle_to_title_content;
    }

    // Iterate over all results
    while (true)
    {
        var test_id = "valgrind.result" + id_num.toString();
        var analysis_cmd_title_span = document.getElementById(test_id + ".Title.Cmd");

        if (analysis_cmd_title_span == null)
        {
            break;
        }

        ++id_num;

        if (toggle_to_title == "unset")
        {
            if (analysis_cmd_title_span.className == "hidden")
            {
                toggle_to_title = "false";
            }
            else
            {
                toggle_to_title = "true";
            }
        }

        var analysis_name_title_span = document.getElementById(test_id + ".Title.Name");

        if (toggle_to_title == "true")
        {
            analysis_cmd_title_span.className = "hidden";
            analysis_name_title_span.className = "";
        }
        else
        {
            analysis_name_title_span.className = "hidden";
            analysis_cmd_title_span.className = "";
        }
    }

    // Restore button onclick action
    current_button.onclick = old_onclick_action;
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

            // Remove the hidden class to the analysis content
            analysis_div.className = "memcheck_analysis_content hidden";
        }
    }
    else
    {
        if (action == "toggle" || action == "expand")
        {
            // Update the visibility image to the collapse one
            visibility_span.innerHTML = "<div class=\"collapse\"><div></div></div>";

            // Add the hidden class to the analysis content
            analysis_div.className = "memcheck_analysis_content";
        }
    }
}
