if( typeof module !== 'undefined' )
require( 'wmathconcepts' );

var _ = wTools;

var box = [ 0, 0, 0, 2, 2, 2 ];
var point = [ 0, 1, 3 ];

debugger;

var clamped = _.box.pointClamp( box, point.slice() );

console.log(clamped,' vs ',point);

dist2 = _.avector.distance(point, clamped);

debugger;

console.log( 'distance :',dist2 );
