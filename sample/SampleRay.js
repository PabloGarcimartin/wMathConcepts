if( typeof module !== 'undefined' )
require( 'wmathconcepts' );

let _ = wTools;

let srcRay = [ 0, 0, -1, 1, 0, 0 ];
var polygon =  _.Space.make( [ 3, 4 ] ).copy
([
  0,   0,   0,   0,
  1,   0, - 1,   0,
  0,   1,   0, - 1
]);

result = _.ray.convexPolygonIntersects( srcRay, polygon );
logger.log( result );
result = _.ray.convexPolygonDistance( srcRay, polygon );
logger.log( result );
result = _.ray.convexPolygonClosestPoint( srcRay, polygon );
logger.log( result );
debugger;
