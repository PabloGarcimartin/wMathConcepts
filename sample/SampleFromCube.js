if( typeof module !== 'undefined' )
require( 'wmathconcepts' );

var _ = wTools;

var box = [ 0, 0, 0, 0, 0, 0 ];
var Oldbox =  [ 0, 0, 0, 0, 0, 0 ];
var vbox = _.vector.from(box);
var cube = [ 2 ] ;

debugger;

var nbox = _.box.fromCube( box, cube );
var vnbox = _.box.fromCube( vbox, cube );

console.log('Array - box:',Oldbox,' - New box: ', nbox);
console.log('Vector - box:',Oldbox,' - New box: ', vnbox);

debugger;
