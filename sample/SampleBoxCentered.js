
if( typeof module !== 'undefined' )
require( 'wmathconcepts' );

var _ = wTools;

var src = undefined;
var got = _.box.centeredOfSize( src );
var expected = [ -0.5,-0.5,-0.5,+0.5,+0.5,+0.5 ];
//test.identical( got,expected );
//test.shouldBe( got !== src );
console.log( 'box centered expected: ',expected );
console.log( 'box centered got: ',got );