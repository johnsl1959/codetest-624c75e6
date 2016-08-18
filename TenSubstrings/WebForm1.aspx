<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="TenSubstrings.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sloan Code Test</title>
    <script type="text/javascript">

        /*************************************************************************************
        *  This function is the onclick event for cmdGetFriendly.  It will find all the 10 
        *   Substring Friendly numbers from zero to the maximum value, entered by the user.
        *   It returns a value which is either the error level (value <= 0) or the amount of
        *   10 Substring Friendly numbers found
        *************************************************************************************
        *   Input parameter(s):
        *       testValStr - string - maximum number to check to (optional - for testing)
        **
        *   Output parameter(s):
        *       retVal - int - values:  >0  - OK    - number of 10 Substring Friendly matches
        *                               0   - ERROR - maximum entered is not large enough
        *                               -1  - ERROR - no maximum input
        *                               -2  - ERROR - maximum input not a number
        *************************************************************************************/

        function cmdGetFriendly_onclick(testValStr) {

            var retVal = 0;
            var MessageStr = "";
            var maxValStr = "";
            var testFlag = false;
            var txtBox = document.getElementById("txtMaxVal");
            var txtArea = document.getElementById("txtAFriendly");

            //  It testing, use the data in testValStr and set testFlag to true, otherwise
            //  use user input and set testFlag to false.

            if (testValStr == undefined) {

                maxValStr = txtBox.value;
                txtArea.value = "";
            }

            else {

                maxValStr = testValStr;
                testFlag = true;
            }

            //   Check input length - minimum length is two, anything less will return no 10
            //   Substring Friendly numbers.
                   
            if (maxValStr.length > 1) {

                //   Check to see if the input is actually a number.

                if (!isNaN(maxValStr)) {

                    //   Iterate from 0 to the maximum value, checking for 10 Substring Friendly numbers.

                    for (var idx = 0; idx <= parseInt(maxValStr) ; ++idx) {

                        //   Check the current number for 10 Substring Friendly.

                        if (isTenSubstringFriendly(idx.toString().split(''))) {

                            //   Write 10 Substring Friendly number (if not a test) and increment the return value.

                            if (!testFlag) { txtArea.value += (txtArea.value.length != 0 ? ',' : '') + idx; }
                            ++retVal;
                        }
                    }
                }

                else { retVal = -1; }
            }

            else { retVal = maxValStr.length == 0 ? -2 : 0; }

            //   If not a test, write any errors.

            if(!testFlag){

                switch (retVal){

                    case -2:
                        txtArea.value = "** NO NUMBER INPUT **";
                        break;

                    case -1:
                        txtArea.value = "** " + maxValStr + " IS NOT A NUMBER **";
                        break;

                    case 0:
                        txtArea.value = "** " + maxValStr + " IS NOT LARGE ENOUGH **";
                        break;
                }
            }
               
            if (!testFlag) { txtBox.value = ''; }
            txtBox.focus();
            txtBox.select();
            return retVal;
        }

        /*************************************************************************************
        *  This function takes a list of single digit integers and checks to see if the whole
        *   list is 10 Substring Friendly.  If it is, return true, otherwise false
        *************************************************************************************
        *   Input parameter(s):
        *       substringAry - array of single digit integers
        **
        *   Output parameter(s):
        *       retVal - boolean
        *************************************************************************************/

        function isTenSubstringFriendly(substringAry) {

            var retVal = false;

            //  If the list has less than two elements, return false.

            if (substringAry != undefined) {

                var strLen = substringAry.length;

                if (strLen > 1) {

                    //  Make a copy, of the list, for consumption by isTenSubstring.

                    var modSubstringAry = substringAry.slice(0, strLen);

                    //  If the list does not begin with a 10 substring, return false.

                    if (isTenSubstring(modSubstringAry)) {

                        //  Since isTenSubstring consumes only as much of the list as is needed
                        //   to determine if it begins with a 10 Substring, the remainder is used to
                        //   determine if isTenSebstring read to the end of the list.  If it did,
                        //   return true, otherwise, drop the first digit from the the unmodified
                        //   list and reevaluate.

                        if (modSubstringAry.length > 0) {

                            substringAry.shift();
                            retVal = isTenSubstringFriendly(substringAry);
                        }

                        else { retVal = true; }
                    }
                }
            }
            return retVal;
        }

        /*************************************************************************************
        *  This function takes a list of single digit integers and sums them until they equal
        *   or exceed 10, then returns true if equal to 10, false otherwise.
        *************************************************************************************
        *   Input parameter(s):
        *       digitAry - array of single digit integers
        *       sumAmt - integer (optional)
        **
        *   Output parameter(s):
        *       retVal - boolean
        *************************************************************************************/

        function isTenSubstring(substringAry, sumAmt) {

            var retVal = false;

            //  Check to make sure there are elements in the list of digits; if not, return
            //   false.

            if (substringAry != undefined && substringAry.length > 0) {

                //  Initialize summation variable, if needed.

                if (sumAmt == undefined) { sumAmt = 0; }

                //  Remove the next digit from the list, and add it to the summation variable.

                sumAmt += parseInt(substringAry.shift());

                //  Check the amount in the summation variable; if less than 10, call the
                //   function again; equals 10, return true; greater than 10, return false.

                if (sumAmt <= 10) {

                    if (sumAmt < 10) {

                        retVal = isTenSubstring(substringAry, sumAmt);
                    }

                    else { retVal = true; }
                }
                return retVal;
            }
        }

        /*************************************************************************************
        *  This function runs regression testingl
        *************************************************************************************
        *   Input parameter(s):
        *       digitAry - array of single digit integers
        *       sumAmt - integer (optional)
        **
        *   Output parameter(s):
        *       retVal - boolean
        *************************************************************************************/

        function functionTests() {

            var retVal;
            var CR = "\r";
            var pass = "\"Passed\"";
            var fail = "\"Failed\"";
            var txtArea = document.getElementById("txtAFriendly");

            document.getElementById("txtMaxVal").value = "Test";
            txtArea.value = "";

            //  First 10 Substring

            txtArea.value += "**  Test Results  **" + CR + CR;

            txtArea.value += "isTenSubstring - No parameter - "                     + (!isTenSubstring() ? pass : fail) + CR;
            txtArea.value += "isTenSubstring - No data - "                          + (!isTenSubstring([]) ? pass : fail) + CR;
            txtArea.value += "isTenSubstring - One element - "                      + (!isTenSubstring([1]) ? pass : fail) + CR;
            txtArea.value += "isTenSubstring - Multiple elements - less than 10 - " + (!isTenSubstring([1, 5]) ? pass : fail) + CR;
            txtArea.value += "isTenSubstring - Multiple elements - equal to 10 - "  + (isTenSubstring([1, 9]) ? pass : fail) + CR;
            txtArea.value += "isTenSubstring - Multiple elements - more to 10 - "   + (!isTenSubstring([9, 9]) ? pass : fail) + CR + CR;

            //  10 Substring Friendly

            txtArea.value += "isTenSubstringFriendly - No parameter - "                     + (!isTenSubstringFriendly() ? pass : fail) + CR;
            txtArea.value += "isTenSubstringFriendly - No data - "                          + (!isTenSubstringFriendly([]) ? pass : fail) + CR;
            txtArea.value += "isTenSubstringFriendly - One element - "                      + (!isTenSubstringFriendly([1]) ? pass : fail) + CR;
            txtArea.value += "isTenSubstringFriendly - Multiple elements - less than 10 - " + (!isTenSubstringFriendly([1, 5]) ? pass : fail) + CR;
            txtArea.value += "isTenSubstringFriendly - Multiple elements - equal to 10 - "  + (isTenSubstringFriendly([1, 9]) ? pass : fail) + CR;
            txtArea.value += "isTenSubstringFriendly - Multiple elements - more to 10 - "   + (!isTenSubstringFriendly([9, 9]) ? pass : fail) + CR + CR;

            //   Full Functionality

            var ary = ['', '1', '12', '30', 'R2D2'];
            var text = "";

            for (var i = 0; i < ary.length; ++i) {

                text = "cmdGetFriendly_onclick - ";
                retVal = cmdGetFriendly_onclick(ary[i]);

                switch (i) {

                    case 0:
                        text += "No data - ";
                        text += retVal == -2 ? pass : fail;
                        break;

                    case 1:
                        text += "Single digit - "
                        text += retVal == 0 ? pass : fail;
                        break;

                    case 2:
                        text += "Two digits, less than 10 - "
                        text += retVal == 0 ? pass : fail;
                        break;

                    case 3:
                        text += "Multiple digits - "
                        text += retVal > 0 ? pass : fail;
                        break;

                    case 4:
                        text += "Multiple digits, not a number - "
                        text += retVal == -1 ? pass : fail;
                        break;
                }
                txtArea.value += text + CR;
            }
        }
    </script>
</head>

<body>
    <form id="form1" runat="server">
        <div style="height:50px; margin-top:25px;text-align:center; width:500px">
            <label style="font-size:large;" >Code Test for John Sloan</label>
        </div>
        <div>
            <textarea id="txtAFriendly" cols="75" name="S1" rows="25"></textarea>
        </div>
        <div style="height:50px; margin-top:25px">
            Enter Maximum Value:&nbsp;&nbsp;
            <input id="txtMaxVal" type="text" autofocus="autofocus" />
        </div>
        <div style="float:left;width:300px;text-align:center">
            <input id="cmdGetFriendly" style="width:200px" type="button" value="Get Friendly Numbers" onclick="cmdGetFriendly_onclick()"/>
        </div>
        <div style="float:left;width:300px;text-align:center">
            <input id="cmdTest" style="width:100px;text-align:center" type="button" value="Test" onclick="functionTests()"/>
        </div>
    </form>
</body>
</html>
