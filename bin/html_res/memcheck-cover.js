/**
 * This function toogles the visibility of the analysis content
 *
 * @param test_id: The analysis report unique ID
 */
function ToogleAnalysisResultVisibility(test_id)
{
    var arrow_span = document.getElementById(test_id + ".Arrow");
    var analysis_div = document.getElementById(test_id + ".Report");

    if (analysis_div.className === "memcheck_analysis_content")
    {
        // Update the arrow for one pointing down
        arrow_span.innerHTML = "&#9658;";

        // Remove the hidden class to the analysis content
        analysis_div.className = "memcheck_analysis_content hidden";
    }
    else
    {
        // Update the arrow for one pointing right
        arrow_span.innerHTML = "&#9660;";

        // Add the hidden class to the analysis content
        analysis_div.className = "memcheck_analysis_content";
    }
}
