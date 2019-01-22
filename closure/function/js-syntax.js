/**
 * partion one: javascript array
 * @type {number[]}
 */
var arrays = [2, 3, 4, 5, 6];
for(var item in arrays) {
    // console.log(item);
}
console.log('arrays.toString:[' + arrays.toString() + ']');

// array.push() method: [2, 3, 4, 5, 6, 7]
arrays.push(7);
console.log('arrays.push:[' +  arrays + ']');

// array.pop() method, return the first element.
console.log('ararys.pop:[' + arrays.pop() + ']');

// arrays.concat()method.
console.log('arrays.concat:[' + arrays.concat([8, 9]) + ']');

// arrays.join() method
console.log('arrays.join:[' + arrays.join(',') + ']');

// arrays.shift() method
console.log('arrays.shift:[' + arrays.shift() + ']');

// arrays.unshift('p') method, return the length of array.
console.log('arrays.unshift:[' + arrays.unshift(0) + ']');

// arrays.slice(1, 2) method
console.log('arrays.slice:[' + arrays.slice(1, 3) + ']');

/**
 * if condition, use strict mode
 */
console.log('strict equals: ' + (5 == "5"));
// strict mode
console.log('strict equals number: ' + (5 === "5"));

var variable;
if(variable) {
    console.log('variable value is: ' + variable)
} else {
    console.log('variable value info: ' + variable == undefined);
}

/**
 * javascript string function
 */
var nation = "china";
console.log("nation info is: " + nation);
// string.length() method
console.log('string.length method: ' + nation.length);
// string.charAt() method
console.log('string.charAt method: ' + nation.charAt(2));