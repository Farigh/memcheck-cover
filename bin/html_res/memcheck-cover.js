/**
 * This function toogles the visibility of the analysis content
 *
 * @param test_id: The analysis report unique ID
 */
function ToogleAnalysisResultVisibility(test_id)
{
    UpdateAnalysisVisibility('toogle', test_id);
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
 * This function processes all results apply the specified action
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
 *    - toogle: Toogles the visibility of the selected test
 * @param test_id: The analysis report unique ID
 */
function UpdateAnalysisVisibility(action, test_id)
{
    var visibility_span = document.getElementById(test_id + ".VisibilityIcon");
    var analysis_div = document.getElementById(test_id + ".Report");

    if (analysis_div.className === "memcheck_analysis_content")
    {
        if (action == "toogle" || action == "collapse")
        {
            // Update the visibility image to the expand one
            visibility_span.innerHTML = "<div class=\"expand\"><div></div></div>";

            // Remove the hidden class to the analysis content
            analysis_div.className = "memcheck_analysis_content hidden";
        }
    }
    else
    {
        if (action == "toogle" || action == "expand")
        {
            // Update the visibility image to the collapse one
            visibility_span.innerHTML = "<div class=\"collapse\"><div></div></div>";

            // Add the hidden class to the analysis content
            analysis_div.className = "memcheck_analysis_content";
        }
    }
}
