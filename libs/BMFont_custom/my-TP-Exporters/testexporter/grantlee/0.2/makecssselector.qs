// create a css selector by replacing -hover with :hover
var MakeSelectorFilter = function(input)
{
  var input = getItemName(input)
  // var input = input.rawString();
  return input.replace("-hover",":hover");
};
// create name in BMFont_custom.fnt to invoke
MakeSelectorFilter.filterName = "makecssselector";
// add the function to TexturePacker Library
Library.addFilter("MakeSelectorFilter");

// create a css selector by replacing -hover with :hover
var getItemName = function(input)
{
  var input = input.rawString();
  var input_l = input.split("/")
  var len = input_l.length
  var input = input_l[len-1]
  return input;
};
// create name in BMFont_custom.fnt to invoke
getItemName.filterName = "getitemname";
// add the function to TexturePacker Library
Library.addFilter("getItemName");

// return the length of array
var GetArrayLength = function(input) {
    return input.length.toString()
};
GetArrayLength.filterName = "getArrayLength";
Library.addFilter("GetArrayLength");

// return the Unicode for input char
var GetUnicode = function(input) {
    space_id = 32
    input=MakeSelectorFilter(input)

    if (input == "space") 
    {
        return space_id.toString()
    };
    return input.charCodeAt(0).toString()
};
GetUnicode.filterName = "getUnicode";
Library.addFilter("GetUnicode");
// getMaxLineHeight from all png array
maxLineH=1;
var GetMaxLineH = function(input) {
    for (index in input){
        if (input[index].frameRect.height > maxLineH){
            maxLineH = input[index].frameRect.height;
        };
    }
    return input[index].frameRect.height.toString();
};
GetMaxLineH.filterName = "getMaxLineH";
Library.addFilter("GetMaxLineH");

// Base on MaxLineHeight get Yoffset
var GetYoffset = function(input) {
    return ((maxLineH - input) / 2).toString();
};
GetYoffset.filterName = "getYoffset";
Library.addFilter("GetYoffset");