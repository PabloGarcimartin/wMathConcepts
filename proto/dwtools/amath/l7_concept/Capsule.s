(function _Capsule_s_(){

'use strict';

let _ = _global_.wTools;
let avector = _.avector;
let vector = _.vector;
let Self = _.capsule = _.capsule || Object.create( null );

/*

  A capsule is a basic geometric shape consisting of a cylinder with hemispherical ends.

  For the following functions, capsules must have the shape [ startX, startY, startZ, endX, endY, endZ, radius ],
where the dimension equals the object´s length minus one, divided by two.

  Moreover, startX, startY and startZ are the coordinates of the center of the bottom circle of the cylinder.
EndX, endY and endZ are the coordinates of the center of the top circle of the cylinder. Finally, radius is
the radius of the cylinder circles and therefore the radius of the capsule hemispherical ends.

*/
// --
//
// --
//


function make( dim )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  let result = _.capsule.makeZero( dim );
  if( _.longIs( dim ) || _.vectorIs( dim ) )
  _.avector.assign( result,dim );
  return result;
}

//

function makeZero( dim )
{
  if( _.longIs( dim ) || _.vectorIs( dim ) )
  dim = _.capsule.dimGet( dim );
  if( dim === undefined || dim === null )
  dim = 3;
  _.assert( dim >= 0 );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  let result = _.dup( 0, dim*2 + 1 );
  return result;
}

//

function makeNil( dim )
{
  if( _.longIs( dim ) || _.vectorIs( dim ) )
  dim = _.capsule.dimGet( dim );
  if( dim === undefined || dim === null )
  dim = 3;

  _.assert( dim >= 0 );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  let result = [];
  for( let i = 0 ; i < dim ; i++ )
  result[ i ] = + Infinity;
  for( let i = 0 ; i < dim + 1; i++ )
  result[ dim + i ] = -Infinity;

  return result;
}

//

function zero( capsule )
{

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( _.longIs( capsule ) || _.vectorIs( capsule ) )
  {
    let capsuleView = _.capsule._from( capsule );
    capsuleView.assign( 0 );
    return capsule;
  }

  return _.capsule.makeZero( capsule );
}

//

function nil( capsule )
{

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( _.longIs( capsule ) || _.vectorIs( capsule ) )
  {
    let capsuleView = _.capsule._from( capsule );
    let min = _.capsule.originGet( capsuleView );
    let max = _.capsule.endPointGet( capsuleView );
    let radius = _.capsule.radiusGet( capsuleView );

    _.vector.assign( min, +Infinity );
    _.vector.assign( max, -Infinity );
    capsuleView.eSet( capsuleView.length - 1, - Infinity );

    return capsule;
  }

  return _.capsule.makeNil( capsule );
}

//

function from( capsule )
{
  _.assert( _.capsule.is( capsule ) || capsule === null );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( capsule === null )
  return _.capsule.make();

  return capsule;
}

//

function _from( capsule )
{
  _.assert( _.capsule.is( capsule ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.vector.from( capsule );
}

//

/**
  * Check if input is a capsule. Returns true if it is a capsule and false if not.
  *
  * @param { Vector } capsule - Source capsule.
  *
  * @example
  * // returns true;
  * _.is( [ 0, 0, 1, 1, 1 ] );
  *
  * @returns { Boolean } Returns true if the input is capsule.
  * @function is
  * @throws { Error } An Error if ( arguments.length ) is different than one.
  * @memberof wTools.capsule
  */
function is( capsule )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  let capsuleView = _.vector.from( capsule );
  let radius = capsuleView.eGet( capsule.length - 1 );
  let isRadius = radius >= 0;
  return ( _.longIs( capsule ) || _.vectorIs( capsule ) ) && ( capsule.length >= 0 ) && ( ( capsule.length - 1 ) % 2 === 0 ) && isRadius;
}

//

/**
  * Get capsule dimension. Returns the dimension of the capsule. capsule stays untouched.
  *
  * @param { Vector } capsule - The source capsule.
  *
  * @example
  * // returns 2
  * _.dimGet( [ 0, 0, 2, 2, 1 ] );
  *
  * @example
  * // returns 1
  * _.dimGet( [ 0, 1, 1 ] );
  *
  * @returns { Number } Returns the dimension of the capsule.
  * @function dimGet
  * @throws { Error } An Error if ( arguments.length ) is different than one.
  * @throws { Error } An Error if ( capsule ) is not capsule.
  * @memberof wTools.capsule
  */
function dimGet( capsule )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.capsule.is( capsule ) );
  return ( capsule.length - 1 ) / 2;
}

//

/**
  * Get the origin of a capsule. Returns a vector with the coordinates of the origin of the capsule.
  * capsule stays untouched.
  *
  * @param { Vector } capsule - The source capsule.
  *
  * @example
  * // returns   0, 0
  * _.originGet( [ 0, 0, 2, 2, 1 ] );
  *
  * @example
  * // returns  1
  * _.originGet( [ 1, 2, 1 ] );
  *
  * @returns { Vector } Returns the coordinates of the origin of the capsule.
  * @function originGet
  * @throws { Error } An Error if ( arguments.length ) is different than one.
  * @throws { Error } An Error if ( capsule ) is not capsule.
  * @memberof wTools.capsule
  */
function originGet( capsule )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  let capsuleView = _.capsule._from( capsule );
  return capsuleView.subarray( 0, ( capsule.length - 1 ) / 2 );
}

//

/**
  * Get the end point of a capsule. Returns a vector with the coordinates of the final point of the capsule.
  * Capsule stays untouched.
  *
  * @param { Vector } capsule - The source capsule.
  *
  * @example
  * // returns   2, 2
  * _.endPointGet( [ 0, 0, 2, 2, 1 ] );
  *
  * @example
  * // returns  2
  * _.endPointGet( [ 1, 2, 1 ] );
  *
  * @returns { Vector } Returns the final point of the capsule.
  * @function endPointGet
  * @throws { Error } An Error if ( arguments.length ) is different than one.
  * @throws { Error } An Error if ( capsule ) is not capsule.
  * @memberof wTools.capsule
  */
function endPointGet( capsule )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  let capsuleView = _.capsule._from( capsule );
  return capsuleView.subarray( ( capsule.length - 1 ) / 2, capsule.length - 1 );
}

//

/**
  * Get the radius of a capsule. Returns a number with the radius of the capsule.
  * Capsule stays untouched.
  *
  * @param { Array } capsule - The source capsule.
  *
  * @example
  * // returns 1
  * _.radiusGet( [ 0, 0, 2, 2, 1 ] );
  *
  * @example
  * // returns  1
  * _.radiusGet( [ 0, 2, 1 ] );
  *
  * @returns { Number } Returns the radius of the capsule.
  * @function radiusGet
  * @throws { Error } An Error if ( arguments.length ) is different than one.
  * @throws { Error } An Error if ( capsule ) is not capsule.
  * @memberof wTools.capsule
  */

function radiusGet( capsule )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  let capsuleView = _.capsule._from( capsule );
  return capsuleView.eGet( capsule.length - 1 );
}

//


/**
  * Set the radius of a capsule. Returns a vector with the capsule including the new radius.
  * Radius stays untouched.
  *
  * @param { Array } capsule - The source and destination capsule.
  * @param { Number } radius - The source radius to set.
  *
  * @example
  * // returns [ 0, 0, 2, 2, 4 ]
  * _.radiusSet( [ 0, 0, 2, 2, 0 ], 4 );
  *
  * @example
  * // returns  [ 0, 1, - 2 ]
  * _.radiusSet( [ 0, 1, 1 ], -2 );
  *
  * @returns { Array } Returns the capsule with the modified radius.
  * @function radiusSet
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( capsule ) is not capsule.
  * @throws { Error } An Error if ( radius ) is not number.
  * @memberof wTools.capsule
  */

function radiusSet( capsule, radius )
{
  _.assert( _.capsule.is( capsule ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( radius ) );
  _.assert( radius >= 0 );

  let capsuleView = _.capsule._from( capsule );

  capsuleView.eSet( capsule.length-1, radius );
  return capsuleView;

  debugger;
}

//

/**
  * Expand the length and radius of a capsule by the dimensions in the expansion array ( expansion values are added ).
  * Returns the expanded capsule. Capsule is stored in Array data structure.
  * The expansion array stays untouched, the capsule changes.
  *
  * @param { Array } capsule - capsule to be expanded.
  * @param { Array } expand - Array of reference with expansion dimensions.
  *
  * @example
  * // returns [ -1, -2, 3, 4, 4 ];
  * _.expand( [ 0, 0, 2, 2, 1 ], [ 1, 2, 3 ] );
  *
  *
  * @returns { Array } Returns the array of the capsule expanded.
  * @function expand
  * @throws { Error } An Error if ( dim ) is different than expand.length - 1 (the capsule and the expansion array don´t have the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( capsule ) is not capsule.
  * @throws { Error } An Error if ( expand ) is not an array.
  * @memberof wTools.capsule
  */
function expand( capsule, expand )
{

  if( capsule === null )
  capsule = _.capsule.make();

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( expand ) || _.longIs( expand ) || _.vectorIs( expand ) );

  let capsuleView = _.capsule._from( capsule );
  let dim = _.capsule.dimGet( capsuleView );
  let min = _.capsule.originGet( capsuleView );
  let max = _.capsule.endPointGet( capsuleView );
  let radius = _.capsule.radiusGet( capsuleView );

  let expandSegment;
  let expandRadius;

  if( _.numberIs( expand ) )
  {
    expandRadius = expand;
    expandSegment = Array( dim ).fill( expand );
  }
  else
  {
    _.assert( dim === expand.length - 1 );

    //expandSegment = expand.splice( 0, expand.length - 1 );
    expandSegment = expand.slice( 0, expand.length - 1 );
    expandRadius = expand[ expand.length - 1 ];
  }

  debugger;

  _.vector.subAssigning( min, expandSegment );
  _.vector.addAssigning( max, expandSegment );

  _.capsule.radiusSet( capsuleView, radius + expandRadius );

  return capsule;
}

//

/**
  * Project a capsule: the projection vector ( projVector ) translates the center of the capsule, and the projection scaling factors ( l, r )
  * scale the segment length ( l ) and the radius ( r ) of the capsule. The projection parameters should have the shape:
  * project = [ projVector, l, r ];
  * Returns the projected capsule. Capsule is stored in Array data structure.
  * The projection array stays untouched, the capsule changes.
  *
  * @param { Array } capsule - capsule to be projected.
  * @param { Array } project - Array of reference with projection parameters.
  *
  * @example
  * // returns [ 1, 1, 3, 3, 2 ];
  * _.project( [ 0, 0, 2, 2, 1 ], [ [ 1, 1 ], 1, 2 ] );
  *
  *
  * @returns { Array } Returns the array of the projected capsule.
  * @function project
  * @throws { Error } An Error if ( dim ) is different than project.length / 2 (the capsule and the projection array don´t have the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( capsule ) is not capsule.
  * @throws { Error } An Error if ( project ) is not an array.
  * @memberof wTools.capsule
  */
function project( capsule, project )
{

  if( capsule === null )
  capsule = _.capsule.make();

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( project ) || _.vectorIs( project ) );
  _.assert( project.length === 3, 'Project array expects exactly three entries')

  let capsuleView = _.capsule._from( capsule );
  let origin = _.vector.from( _.capsule.originGet( capsuleView ) );
  let end = _.vector.from( _.capsule.endPointGet( capsuleView ) );
  let radius = _.capsule.radiusGet( capsuleView );
  let dim = _.capsule.dimGet( capsuleView );
  let projectView = _.vector.from( project );

  let projVector = _.vector.from( projectView.eGet( 0 ) );
  _.assert( dim === projVector.length );
  let scalLength = projectView.eGet( 1 );
  let scalRadius = projectView.eGet( 2 );

  let capsuleSegment = _.segment.fromPair( [ origin, end ] );
  let center = _.vector.from( _.segment.centerGet( capsuleSegment ) );

  let segTop = _.vector.mulScalar( _.vector.subVectors( end.clone(), center ), scalLength );
  let segSub = _.vector.mulScalar( _.vector.subVectors( origin.clone(), center ), scalLength );

  let newCenter = _.vector.addVectors( center.clone(), projVector );
  let newOrigin = _.vector.addVectors( newCenter.clone(), segSub );
  let newEnd = _.vector.addVectors( newCenter.clone(), segTop );
  let newRadius = scalRadius * radius;

  debugger;

  for( let i = 0; i < dim; i ++ )
  {
    capsuleView.eSet( i, newOrigin.eGet( i ) );
    capsuleView.eSet( i + dim, newEnd.eGet( i ) );
  }

  capsuleView.eSet( capsuleView.length - 1, newRadius );
  return capsule;
}

//

/**
  * Get the projection factors of two capsules: the projection vector ( projVector ) translates the center of the capsule, and the projection scaling factors( l, r )
  * scale the segment length ( l ) and the radius ( r ) of the capsule. The projection parameters should have the shape:
  * project = [ projVector, l, r ];
  * Returns the projection parameters, 0 when not possible ( i.e: srcCapsule is a point and projCapsule is a capsule - no scaling factors ).
  * Capsules are stored in Array data structure. The capsules stay untouched.
  *
  * @param { Array } srcCapsule - Original capsule.
  * @param { Array } projCapsule - Projected capsule.
  *
  * @example
  * // returns [ [ 0.5, 0.5 ], 2, 2 ];
  * _.getProjectionFactors( [ 0, 0, 1, 1, 1 ], [ -0.5, -0.5, 2.5, 2.5, 2 ] );
  *
  *
  * @returns { Array } Returns the array with the projection factors between the two capsulees.
  * @function getProjectionFactors
  * @throws { Error } An Error if ( dim ) is different than ( dim2 ) (the capsules don´t have the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( projCapsule ) is not capsule.
  * @memberof wTools.capsule
  */
function getProjectionFactors( srcCapsule, projCapsule )
{

  _.assert( _.capsule.is( srcCapsule ), 'Expects capsule' );
  _.assert( _.capsule.is( projCapsule ), 'Expects capsule' );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let srcOrigin = _.vector.from( _.capsule.originGet( srcCapsuleView ) );
  let srcEnd = _.vector.from( _.capsule.endPointGet( srcCapsuleView ) );
  let srcRadius = _.capsule.radiusGet( srcCapsuleView );
  let srcDim = _.capsule.dimGet( srcCapsuleView );

  let projCapsuleView = _.capsule._from( projCapsule );
  let projOrigin = _.vector.from( _.capsule.originGet( projCapsuleView ) );
  let projEnd = _.vector.from( _.capsule.endPointGet( projCapsuleView ) );
  let projRadius = _.capsule.radiusGet( projCapsuleView );
  let projDim = _.capsule.dimGet( projCapsuleView );

  _.assert( srcDim === projDim );

  let project = _.array.makeArrayOfLength( 3 );
  let projectView = _.vector.from( project );

  let srcCapsuleSegment = _.segment.fromPair( [ srcOrigin, srcEnd ] );
  let srcCenter = _.vector.from( _.segment.centerGet( srcCapsuleSegment ) );
  let srcDir = _.vector.subVectors( srcEnd.clone(), srcOrigin );

  let projCapsuleSegment = _.segment.fromPair( [ projOrigin, projEnd ] );
  let projCenter = _.vector.from( _.segment.centerGet( projCapsuleSegment ) );
  let projDir = _.vector.subVectors( projEnd.clone(), projOrigin );

  debugger;
  if( !_.segment.segmentParallel( srcCapsuleSegment, projCapsuleSegment, 1e-7 )  )
  return 0;

  let translation = _.vector.subVectors( projCenter.clone(), srcCenter );
  projectView.eSet( 0, translation.toArray() );

  let srcTop = _.vector.subVectors( srcEnd.clone(), srcCenter );
  let projTop = _.vector.subVectors( projEnd.clone(), projCenter );
  debugger;

  let srcTopMag = _.vector.mag( srcTop);
  let projTopMag = _.vector.mag( projTop);

  let scalLength;
  if( srcTopMag === 0 )
  {
    if( projTopMag === 0 )
    {
      scalLength = 1;
    }
    else return 0;
  }
  else
  {
    scalLength = projTopMag / srcTopMag;
  }
  projectView.eSet( 1, scalLength );

  let scalRadius;
  if( srcRadius === 0 )
  {
    if( projRadius === 0 )
    {
      scalRadius = 1;
    }
    else return 0;
  }
  else
  {
    scalRadius = projRadius / srcRadius;
  }
  projectView.eSet( 2, scalRadius );

  return project;
}

//

/**
  * Check if a given point is contained inside a capsule. Returs true if it is contained, false if not.
  * Point and capsule stay untouched.
  *
  * @param { Array } srcCapsule - The source capsule.
  * @param { Array } srcPoint - The source point.
  *
  * @example
  * // returns true
  * _.pointContains( [ 0, 0, 2, 2, 1 ], [ 1, 1 ] );
  *
  * @example
  * // returns false
  * _.pointContains( [ 0, 0, 2, 2, 1 ], [ - 1, 3 ] );
  *
  * @returns { Boolen } Returns true if the point is inside the capsule, and false if the point is outside it.
  * @function pointContains
  * @throws { Error } An Error if ( dim ) is different than point.length (capsule and point have not the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcPoint ) is not point.
  * @memberof wTools.capsule
  */
function pointContains( srcCapsule, srcPoint )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( srcPoint ) || _.vectorIs( srcPoint ) );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcPoint.length );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  let dimension  = _.capsule.dimGet( srcCapsuleView );
  let srcPointView = _.vector.from( srcPoint.slice() );

  _.assert( dimension === srcPoint.length, 'The capsule and the point must have the same dimension' );

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.pointDistance( srcSegment, srcPointView );
  if( distance <= radius )
  {
    return true;
  }
  else
  {
    return false;
  }
}

//

/**
  * Get the distance between a point and a capsule. Returs the calculated distance. Point and capsule stay untouched.
  *
  * @param { Array } srcCapsule - The source capsule.
  * @param { Array } srcPoint - The source point.
  *
  * @example
  * // returns 0
  * _.pointDistance( [ 0, 0, 0, 2, 1 ], [ 0, 1 ] );
  *
  * @example
  * // returns 1
  * _.pointDistance( [ 0, 0, 0, 2, 1 ], [ 2, 2 ] );
  *
  * @returns { Boolen } Returns the distance between the point and the capsule.
  * @function pointDistance
  * @throws { Error } An Error if ( dim ) is different than point.length (capsule and point have not the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcPoint ) is not point.
  * @memberof wTools.capsule
  */
function pointDistance( srcCapsule, srcPoint )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcPoint.length );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  let dimension  = _.capsule.dimGet( srcCapsuleView );
  let srcPointView = _.vector.from( srcPoint.slice() );

  _.assert( dimension === srcPoint.length, 'The capsule and the point must have the same dimension' );

  if( _.capsule.pointContains( srcCapsuleView, srcPointView ) )
  {
    return 0;
  }
  else
  {
    let srcSegment = _.segment.fromPair( [ origin, end ] );

    let distance = _.segment.pointDistance( srcSegment, srcPointView );

    return distance - radius;
  }
}

/**
  * Get the closest point between a point and a capsule. Returs the calculated point. srcPoint and capsule stay untouched.
  *
  * @param { Array } srcCapsule - The source capsule.
  * @param { Array } srcPoint - The source point.
  * @param { Array } dstPoint - The destination point.
  *
  * @example
  * // returns 0
  * _.pointClosestPoint( [ 0, 0, 0, 2, 1 ], [ 0, 1 ] );
  *
  * @example
  * // returns [ 1, 2 ]
  * _.pointClosestPoint( [ 0, 0, 0, 2, 1 ], [ 2, 2 ] );
  *
  * @returns { Boolen } Returns the closest point in a capsule to a point.
  * @function pointClosestPoint
  * @throws { Error } An Error if ( dim ) is different than point.length (capsule and point have not the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcPoint ) is not point.
  * @memberof wTools.capsule
  */
function pointClosestPoint( srcCapsule, srcPoint, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( srcPoint.length );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcPoint.length );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimension  = _.capsule.dimGet( srcCapsuleView );
  let srcPointView = _.vector.from( srcPoint.slice() );
  let dstPointView = _.vector.from( dstPoint );

  _.assert( dimension === srcPoint.length, 'The capsule and the point must have the same dimension' );

  if( _.capsule.pointContains( srcCapsuleView, srcPointView ) )
  {
    for( let i = 0; i < srcPointView.length; i++ )
    {
      dstPointView.eSet( i, srcPointView.eGet( i ) );
    }
  }
  else
  {
    let pointVector = _.vector.from( _.array.makeArrayOfLengthZeroed( dimension ));

    let srcSegment = _.segment.fromPair( [ origin, end ] );

    let center = _.segment.pointClosestPoint( srcSegment, srcPointView );
    let sphere = _.sphere.make( dimension );
    _.sphere.fromCenterAndRadius( sphere, center, radius );
    pointVector = _.vector.from( _.sphere.pointClosestPoint( sphere, srcPointView ) );

    for( let i = 0; i < pointVector.length; i++ )
    {
      dstPointView.eSet( i, pointVector.eGet( i ) );
    }
  }

  return dstPoint;
}

//

/**
  * Check if a capsule contains a box. Returns true if it contains the box and false if not.
  * The box and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcBox - Source box.
  *
  * @example
  * // returns true;
  * _.boxContains( [ 0, 0, 0, 2, 2, 2, 2 ] , [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns false;
  * _.boxContains( [ 0, -1, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 2, 2, 2 ]);
  *
  * @returns { Boolean } Returns true if the capsule and the box contains.
  * @function boxContains
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcBox ) is not box.
  * @throws { Error } An Error if ( dim ) is different than box.dimGet (the capsule and box don´t have the same dimension).
  * @memberof wTools.capsule
  */
function boxContains( srcCapsule, srcBox )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcBox.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let boxView = _.box._from( srcBox );
  let dimBox = _.box.dimGet( boxView );

  _.assert( dimCapsule === dimBox );

  /* box corners */
  let c = _.box.cornersGet( boxView );

  for( let j = 0 ; j < _.Space.dimsOf( c )[ 1 ] ; j++ )
  {
    let corner = c.colVectorGet( j );

    if( !_.capsule.pointContains( srcCapsuleView, corner ) )
    return false;
  }

  return true;

}

//

/**
  * Check if a capsule and a box intersect. Returns true if they intersect and false if not.
  * The box and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcBox - Source box.
  *
  * @example
  * // returns true;
  * _.boxIntersects( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns false;
  * _.boxIntersects( [ 0, -1, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 2, 2, 2 ]);
  *
  * @returns { Boolean } Returns true if the capsule and the box intersect.
  * @function boxIntersects
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcBox ) is not box.
  * @throws { Error } An Error if ( dim ) is different than box.dimGet (the capsule and box don´t have the same dimension).
  * @memberof wTools.capsule
  */
function boxIntersects( srcCapsule, srcBox )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcBox.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let boxView = _.box._from( srcBox );
  let dimBox = _.box.dimGet( boxView );

  _.assert( dimCapsule === dimBox );

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.boxDistance( srcSegment, boxView );

  if( distance <= radius )
  { return true; }

  return false;

}

//

/**
  * Get the distance between a capsule and a box. Returns the calculated distance.
  * The box and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcBox - Source box.
  *
  * @example
  * // returns 0;
  * _.boxDistance( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns Math.sqrt( 12 ) - 1;
  * _.boxDistance( [ 0, 0, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 2, 2, 2 ]);
  *
  * @returns { Number } Returns the distance between the capsule and the box.
  * @function boxDistance
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcBox ) is not box.
  * @throws { Error } An Error if ( dim ) is different than box.dimGet (the capsule and box don´t have the same dimension).
  * @memberof wTools.capsule
  */
function boxDistance( srcCapsule, srcBox )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcBox.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let boxView = _.box._from( srcBox );
  let dimBox = _.box.dimGet( boxView );

  _.assert( dimCapsule === dimBox );

  if( _.capsule.boxIntersects( srcCapsuleView, boxView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.boxDistance( srcSegment, boxView );

  return distance - radius;
}

//

/**
  * Get the closest point in a capsule to a box. Returns the calculated point.
  * The box and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcBox - Source box.
  * @param { Array } dstPoint - Destination Point (optional).
  *
  * @example
  * // returns 0;
  * _.boxClosestPoint( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns [ 0, 0, 0 ];
  * _.boxClosestPoint( [ 0, - 1, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 2, 2, 2 ]);
  *
  * @returns { Number } Returns the closest point in the capsule to the box.
  * @function boxClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcBox ) is not box.
  * @throws { Error } An Error if ( dim ) is different than box.dimGet (the capsule and box don´t have the same dimension).
  * @memberof wTools.capsule
  */
function boxClosestPoint( srcCapsule, srcBox, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( srcBox.length / 2 );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcBox.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let boxView = _.box._from( srcBox );
  let dimBox = _.box.dimGet( boxView );
  let min = _.vector.from( _.box.cornerLeftGet( boxView ) );
  let max = _.vector.from( _.box.cornerRightGet( boxView ) );

  let dstPointView = _.vector.from( dstPoint );
  _.assert( dimCapsule === dimBox );

  if( _.capsule.boxIntersects( srcCapsuleView, boxView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let center = _.segment.boxClosestPoint( srcSegment, boxView );
  let sphere = _.sphere.make( dimBox );
  _.sphere.fromCenterAndRadius( sphere, center, radius );
  let point =_.sphere.boxClosestPoint( sphere, boxView );

  let pointView = _.vector.from( point );
  for( let i = 0; i < pointView.length; i++ )
  {
    dstPointView.eSet( i, pointView.eGet( i ) );
  }

  return dstPoint;
}

//

/**
  * Get the bounding box of a capsule. Returns destination box.
  * Capsule and box are stored in Array data structure. Source capsule stays untouched.
  *
  * @param { Array } dstBox - destination box.
  * @param { Array } srcCapsule - source capsule for the bounding box.
  *
  * @example
  * // returns [ - 1, - 1, - 1, 3, 3, 3 ]
  * _.boundingBoxGet( null, [ 0, 0, 0, 2, 2, 2, 1 ] );
  *
  * @returns { Array } Returns the array of the bounding box.
  * @function boundingBoxGet
  * @throws { Error } An Error if ( dim ) is different than dimGet(capsule) (the capsule and the box don´t have the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( dstBox ) is not box
  * @throws { Error } An Error if ( srcCapsule ) is not capsule
  * @memberof wTools.capsule
  */
function boundingBoxGet( dstBox, srcCapsule )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  if( dstBox === null || dstBox === undefined )
  dstBox = _.box.makeNil( dimCapsule );

  _.assert( _.box.is( dstBox ) );
  let dimB = _.box.dimGet( dstBox );

  _.assert( dimCapsule === dimB );

  let center = origin.clone();
  _.vector.addVectors( center, end );
  _.vector.mulScalar( center, 0.5 );

  let size = end.clone();
  _.vector.abs( size, _.vector.addVectors( size, _.vector.mulScalar( origin.clone(), - 1 ) ) ); // Get size
  _.vector.addScalar( size, 2*radius )  // Add radius

  let boxView = _.box._from( dstBox );
  let box = _.box._from( _.box.fromCenterAndSize( null, center, size ) );

  for( let b = 0; b < boxView.length; b++ )
  {
    boxView.eSet( b, box.eGet( b ) );
  }

  return dstBox;
}

//

/**
  * Check if a capsule contains a capsule. Returns true if it contains the capsule and false if not.
  * The capsules remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule ( container ).
  * @param { Array } tstCapsule - Source capsule ( content ).
  *
  * @example
  * // returns true;
  * _.capsuleContains( [ 0, 0, 0, 2, 2, 2, 2 ] , [ 0, 0, 0, 1, 1, 1, 1 ]);
  *
  * @example
  * // returns false;
  * _.capsuleContains( [ 0, -1, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 2, 2, 2, 2 ]);
  *
  * @returns { Boolean } Returns true if the capsule is contained, and false if not.
  * @function capsuleContains
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( tstCapsule ) is not capsule.
  * @throws { Error } An Error if ( dim ) is different than capsule.dimGet (the capsules don´t have the same dimension).
  * @memberof wTools.capsule
  */
function capsuleContains( srcCapsule, tstCapsule )
{

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let dimSrc = _.capsule.dimGet( srcCapsuleView );
  let tstCapsuleView = _.capsule._from( tstCapsule );
  let dimTst = _.capsule.dimGet( tstCapsuleView );
  let origin = _.vector.from( _.capsule.originGet( tstCapsuleView ) );
  let end = _.vector.from( _.capsule.endPointGet( tstCapsuleView ) );
  let radius = _.capsule.radiusGet( tstCapsuleView );

  _.assert( dimSrc === dimTst );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let bottomSphere = _.sphere.fromCenterAndRadius( null, origin, radius );
  let topSphere = _.sphere.fromCenterAndRadius( null, end, radius );

  if( !_.capsule.sphereContains( srcCapsuleView, bottomSphere ) )
  return false;

  if( !_.capsule.sphereContains( srcCapsuleView, topSphere ) )
  return false;

  return true;
}

//

/**
  * Check if two capsules intersect. Returns true if they intersect and false if not.
  * The capsules remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } tstCapsule - Test capsule.
  *
  * @example
  * // returns true;
  * _.capsuleIntersects( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 0, 0, 0, 1, 1, 1, 0 ]);
  *
  * @example
  * // returns false;
  * _.capsuleIntersects( [ 0, -1, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 2, 2, 2, 1 ]);
  *
  * @returns { Boolean } Returns true if the capsules intersect.
  * @function capsuleIntersects
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( tstCapsule ) is not capsule.
  * @throws { Error } An Error if ( dim ) is different than capsule.dimGet (the capsules don´t have the same dimension).
  * @memberof wTools.capsule
  */
function capsuleIntersects( srcCapsule, tstCapsule )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( _.capsule.dimGet( tstCapsule ) );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let srcDim  = _.capsule.dimGet( srcCapsuleView );

  let tstCapsuleView = _.capsule._from( tstCapsule );
  let tstOrigin = _.capsule.originGet( tstCapsuleView );
  let tstEnd = _.capsule.endPointGet( tstCapsuleView );
  let tstRadius = _.capsule.radiusGet( tstCapsuleView );
  _.assert( tstRadius >= 0 );
  let tstDim  = _.capsule.dimGet( tstCapsuleView );

  _.assert( srcDim === tstDim );

  let srcSegment = _.segment.fromPair( [ origin, end ] );
  let tstSegment = _.segment.fromPair( [ tstOrigin, tstEnd ] );

  let distance = _.segment.segmentDistance( srcSegment, tstSegment );

  if( distance <= radius + tstRadius )
  { return true; }

  return false;

}

//

/**
  * Get the distance between twp capsules. Returns the calculated distance.
  * The capsules remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } tstCapsule - Test capsule.
  *
  * @example
  * // returns 0;
  * _.capsuleDistance( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 0, 0, 0, 1, 1, 1, 0 ]);
  *
  * @example
  * // returns Math.sqrt( 12 ) - 1;
  * _.capsuleDistance( [ 0, 0, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 2, 2, 2, 0 ]);
  *
  * @returns { Number } Returns the distance between two capsules.
  * @function capsuleDistance
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( tstCapsule ) is not capsule.
  * @throws { Error } An Error if ( dim ) is different than capsule.dimGet (the capsules don´t have the same dimension).
  * @memberof wTools.capsule
  */
function capsuleDistance( srcCapsule, tstCapsule )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );


  if( srcCapsule === null )
  srcCapsule = _.capsule.make( _.capsule.dimGet( tstCapsule ) );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let srcDim  = _.capsule.dimGet( srcCapsuleView );

  let tstCapsuleView = _.capsule._from( tstCapsule );
  let tstOrigin = _.capsule.originGet( tstCapsuleView );
  let tstEnd = _.capsule.endPointGet( tstCapsuleView );
  let tstRadius = _.capsule.radiusGet( tstCapsuleView );
  _.assert( tstRadius >= 0 );
  let tstDim  = _.capsule.dimGet( tstCapsuleView );

  _.assert( srcDim === tstDim );

  if( _.capsule.capsuleIntersects( srcCapsuleView, tstCapsuleView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );
  let tstSegment = _.segment.fromPair( [ tstOrigin, tstEnd ] );

  let distance = _.segment.segmentDistance( srcSegment, tstSegment );

  return distance - ( radius + tstRadius );
}

//

/**
  * Get the closest point in a capsule to a capsule. Returns the calculated point.
  * The capsules remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } tstCapsule - Test capsule.
  * @param { Array } dstPoint - Destination Point (optional).
  *
  * @example
  * // returns 0;
  * _.capsuleClosestPoint( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 0, 0, 0, 1, 1, 1, 0 ]);
  *
  * @example
  * // returns [ 0, 0, 0 ];
  * _.capsuleClosestPoint( [ 0, - 1, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 2, 2, 2, 0 ]);
  *
  * @returns { Number } Returns the closest point in the capsule to the capsule.
  * @function capsuleClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( tstCapsule ) is not capsule.
  * @throws { Error } An Error if ( dim ) is different than capsule.dimGet (the capsules don´t have the same dimension).
  * @memberof wTools.capsule
  */
function capsuleClosestPoint( srcCapsule, tstCapsule, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( _.capsule.dimGet( tstCapsule ) );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let srcDim  = _.capsule.dimGet( srcCapsuleView );

  let tstCapsuleView = _.capsule._from( tstCapsule );
  let tstOrigin = _.capsule.originGet( tstCapsuleView );
  let tstEnd = _.capsule.endPointGet( tstCapsuleView );
  let tstRadius = _.capsule.radiusGet( tstCapsuleView );
  _.assert( tstRadius >= 0 );
  let tstDim  = _.capsule.dimGet( tstCapsuleView );

  _.assert( srcDim === tstDim );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( srcDim );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  let dstPointView = _.vector.from( dstPoint );
  _.assert( tstDim === srcDim );

  if( _.capsule.capsuleIntersects( srcCapsuleView, tstCapsuleView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );
  let tstSegment = _.segment.fromPair( [ tstOrigin, tstEnd ] );

  let center = _.segment.segmentClosestPoint( srcSegment, tstSegment );
  let sphere = _.sphere.make( srcDim );
  _.sphere.fromCenterAndRadius( sphere, center, radius );
  let point =_.sphere.segmentClosestPoint( sphere, tstSegment );

  let pointView = _.vector.from( point );
  for( let i = 0; i < pointView.length; i++ )
  {
    dstPointView.eSet( i, pointView.eGet( i ) );
  }

  return dstPoint;
}

//

/**
  * Check if a given convex polygon is contained inside a capsule. Returs true if it is contained, false if not. Polygon and capsule stay untouched.
  *
  * @param { Array } capsule - The capsule to check if the convex polygon is inside.
  * @param { Polygon } convex polygon - The convex polygon to check.
  *
  * @example
  * // returns true
  * let polygon = _.Space.make( [ 3, 4 ] ).copy
  *  ([ 0,   1,   1,   0,
  *     0,   1,   1,   0,
  *     0,   1,   3,   3 ] );
  * _.convexPolygonContains( [ 0, 0, 0, 3, 3, 3, 1 ], polygon );
  *
  * @returns { Boolen } Returns true if the convexPolygon is inside the capsule, and false if not.
  * @function convexPolygonContains
  * @throws { Error } An Error if ( dim ) is different than convexPolygon.length (Box and polygon don´t have the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( capsule ) is not capsule.
  * @throws { Error } An Error if ( convexPolygon ) is not convexPolygon.
  * @memberof wTools.capsule
  */


function convexPolygonContains( capsule, polygon )
{

  let capsuleView = _.capsule._from( capsule );
  let dimC = _.capsule.dimGet( capsuleView );
  let dimP =  _.Space.dimsOf( polygon );

  _.assert( dimC === dimP[ 0 ] );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  for( let i = 0; i < dimP[ 1 ]; i++ )
  {
    let vertex = polygon.colVectorGet( i );
    if( !_.capsule.pointContains( capsuleView, vertex ) )
    return false;
  }

  return true;
}

//

function convexPolygonIntersects( srcCapsule , polygon )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.convexPolygon.is( polygon ) );
  let capsuleView = _.capsule._from( srcCapsule );

  let gotBool = _.convexPolygon.capsuleIntersects( polygon, capsuleView );

  return gotBool;
}

//

function convexPolygonDistance( srcCapsule , polygon )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.convexPolygon.is( polygon ) );
  let capsuleView = _.capsule._from( srcCapsule );

  let gotDist = _.convexPolygon.capsuleDistance( polygon, capsuleView );

  return gotDist;
}

//

/**
  * Calculates the closest point in a capsule to a convex polygon. Returns the calculated point.
  * Capsule and polygon remain unchanged
  *
  * @param { Array } capsule - The source capsule.
  * @param { Polygon } polygon - The source polygon.
  * @param { Array } dstPoint - The destination point.
  *
  * @example
  * // returns [ 1.5, 1.5, 1.5 ]
  * let polygon = _.Space.make( [ 3, 4 ] ).copy
  *  ([
  *    0,   0,   0,   0,
  *    1,   0, - 1,   0,
  *    0,   1,   0, - 1
  *  ]);
  * _.convexPolygonClosestPoint( [ 1.5, 1.5, 1.5, 2, 2, 2 ], polygon );
  *
  * @returns { Array } Returns the closest point to the polygon.
  * @function convexPolygonClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( capsule ) is not capsule
  * @throws { Error } An Error if ( polygon ) is not convexPolygon
  * @throws { Error } An Error if ( dstPoint ) is not point
  * @memberof wTools.capsule
  */
function convexPolygonClosestPoint( capsule, polygon, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );
  _.assert( _.convexPolygon.is( polygon ) );

  let capsuleView = _.capsule._from( capsule );
  let dimB = _.capsule.dimGet( capsuleView );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( dimB );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Null or undefined dstPoint is not allowed' );

  let dimP  = _.Space.dimsOf( polygon );

  let dstPointView = _.vector.from( dstPoint );

  _.assert( dimB === dstPoint.length );
  _.assert( dimP[ 0 ] === dimB );

  if( _.convexPolygon.capsuleIntersects( polygon, capsuleView ) )
  return 0
  else
  {
    let polygonPoint = _.convexPolygon.capsuleClosestPoint( polygon, capsuleView );

    let capsulePoint = _.vector.from( _.capsule.pointClosestPoint( capsuleView, polygonPoint ) );

    for( let i = 0; i < dimB; i++ )
    {
      dstPointView.eSet( i, capsulePoint.eGet( i ) );
    }

    return dstPoint;
  }

}

//

/**
  * Check if a capsule contains a frustum. Returns true if it is contained, false if not.
  * Capsule and frustum remain unchanged
  *
  * @param { Array } capsule - The source capsule (container).
  * @param { Space } frustum - The tested frustum (the frustum to check if it is contained in capsule).
  *
  * @example
  * // returns true
  * let frustum =  _.Space.make( [ 4, 6 ] ).copy
  * ([
  *   0,   0,   0,   0, - 1,   1,
  *   1, - 1,   0,   0,   0,   0,
  *   0,   0,   1, - 1,   0,   0,
  *   - 1,   0, - 1,   0,   0, - 1 ]
  * );
  * _.frustumContains( [ 0, 0, 0, 2, 2, 2, 1 ], frustum );
  *
  * @example
  * // returns false
  * _.frustumContains( [ 2, 2, 2, 3, 3, 3, 1 ], frustum );
  *
  * @returns { Boolean } Returns true if the frustum is contained and false if not.
  * @function frustumContains
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( capsule ) is not capsule
  * @throws { Error } An Error if ( frustum ) is not frustum
  * @memberof wTools.capsule
  */
function frustumContains( capsule, frustum )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.frustum.is( frustum ) );
  let capsuleView = _.capsule._from( capsule );
  let dim = _.capsule.dimGet( capsuleView );
  let dims = _.Space.dimsOf( frustum );
  _.assert( dim = dims[ 0 ], 'Frustum and capsule must have same dim');

  let fpoints = _.frustum.cornersGet( frustum );
  let dimPoints = _.Space.dimsOf( fpoints );
  _.assert( _.spaceIs( fpoints ) );

  for( let i = 0 ; i < dimPoints[ 1 ] ; i += 1 )
  {
    let point = fpoints.colVectorGet( i );

    if( _.capsule.pointContains( capsule, point ) !== true )
    {
      return false;
    }
  }
  return true;
}

//

/**
  * Check if a capsule and a frustum intersect. Returns true if they intersect and false if not.
  * The frustum and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcFrustum - Source frustum.
  *
  * @example
  * // returns true;
  * var srcFrustum =  _.Space.make( [ 4, 6 ] ).copy
  * ([
  *   0,   0,   0,   0, - 1,   1,
  *   1, - 1,   0,   0,   0,   0,
  *   0,   0,   1, - 1,   0,   0,
  *   - 1,   0, - 1,   0,   0, - 1
  * ]);
  * _.frustumIntersects( [ 0, 0, 0, 2, 2, 2, 1 ] , srcFrustum );
  *
  * @example
  * // returns false;
  * _.frustumIntersects( [ 0, -2, 0, 0, -3, 1, 0.5 ] , srcFrustum );
  *
  * @returns { Boolean } Returns true if the capsule and the frustum intersect.
  * @function frustumIntersects
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcFrustum ) is not frustum.
  * @throws { Error } An Error if ( dim ) is different than frustum.dimGet (the capsule and frustum don´t have the same dimension).
  * @memberof wTools.capsule
  */
function frustumIntersects( srcCapsule, srcFrustum )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.frustum.is( srcFrustum ) );

  let dimFrustum = _.Space.dimsOf( srcFrustum ) ;
  let rows = dimFrustum[ 0 ];
  let cols = dimFrustum[ 1 ];

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( rows - 1 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  _.assert( dimCapsule === rows - 1 );

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.frustumDistance( srcSegment, srcFrustum );

  if( distance <= radius + _.accuracy )
  return true;

  return false;
}

//

/**
  * Get the distance between a capsule and a frustum. Returns the calculated distance.
  * The frustum and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcFrustum - Source frustum.
  *
  * @example
  * // returns 0;
  * var srcFrustum =  _.Space.make( [ 4, 6 ] ).copy
  * ([
  *   0,   0,   0,   0, - 1,   1,
  *   1, - 1,   0,   0,   0,   0,
  *   0,   0,   1, - 1,   0,   0,
  *   - 1,   0, - 1,   0,   0, - 1
  * ]);
  * _.frustumDistance( [ 0, 0, 0, 2, 2, 2, 1 ], srcFrustum );
  *
  * @example
  * // 1;
  * _.frustumDistance( [ 0, - 2, 0, 0, -3, 0, 1 ], srcFrustum );
  *
  * @returns { Number } Returns the distance between a capsule and a frustum.
  * @function frustumDistance
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcFrustum ) is not frustum.
  * @throws { Error } An Error if ( dim ) is different than frustum.dimGet (the capsule and frustum don´t have the same dimension).
  * @memberof wTools.capsule
  */
function frustumDistance( srcCapsule, srcFrustum )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.frustum.is( srcFrustum ) );

  let dimFrustum = _.Space.dimsOf( srcFrustum ) ;
  let rows = dimFrustum[ 0 ];
  let cols = dimFrustum[ 1 ];

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( rows - 1 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  _.assert( dimCapsule === rows - 1 );

  if( _.capsule.frustumIntersects( srcCapsuleView, srcFrustum ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.frustumDistance( srcSegment, srcFrustum )

  return distance - radius;
}

//

/**
  * Get the closest point in a capsule to a frustum. Returns the calculated point.
  * The frustum and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcFrustum - Source frustum.
  *
  * @example
  * // returns 0;
  * var srcFrustum =  _.Space.make( [ 4, 6 ] ).copy
  * ([
  *   0,   0,   0,   0, - 1,   1,
  *   1, - 1,   0,   0,   0,   0,
  *   0,   0,   1, - 1,   0,   0,
  *   - 1,   0, - 1,   0,   0, - 1
  * ]);
  * _.frustumClosestPoint( [ 0, 0, 0, 2, 2, 2, 1 ] , srcFrustum );
  *
  * @example
  * // returns [ 0, - 0.5, 0 ];
  * _.frustumClosestPoint( [ 0, - 1, 0, 0, -2, 0, 0.5 ] , srcFrustum );
  *
  * @returns { Array } Returns the closest point in the capsule to the frustum.
  * @function frustumClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcFrustum ) is not frustum.
  * @throws { Error } An Error if ( dim ) is different than frustum.dimGet (the capsule and frustum don´t have the same dimension).
  * @memberof wTools.capsule
  */
function frustumClosestPoint( srcCapsule, srcFrustum, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );
  _.assert( _.frustum.is( srcFrustum ) );

  let dimFrustum = _.Space.dimsOf( srcFrustum ) ;
  let rows = dimFrustum[ 0 ];
  let cols = dimFrustum[ 1 ];

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( rows - 1 );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( rows - 1 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let dstPointView = _.vector.from( dstPoint );
  _.assert( dimCapsule === rows - 1 );

  if( _.capsule.frustumIntersects( srcCapsuleView, srcFrustum ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let center = _.segment.frustumClosestPoint( srcSegment, srcFrustum );
  let sphere = _.sphere.make( dimCapsule );
  _.sphere.fromCenterAndRadius( sphere, center, radius );
  let pointView =_.sphere.frustumClosestPoint( sphere, srcFrustum );

  pointView = _.vector.from( pointView );
  for( let i = 0; i < pointView.length; i++ )
  {
    dstPointView.eSet( i, pointView.eGet( i ) );
  }

  return dstPoint;
}

//

/**
  * Check if a capsule and a line intersect. Returns true if they intersect and false if not.
  * The line and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcLine - Source line.
  *
  * @example
  * // returns true;
  * var srcLine =  [ -1, -1, -1, 1, 1, 1 ]
  * var srcCapsule = [ 0, 0, 0, 2, 2, 2, 1 ]
  * _.lineIntersects( srcCapsule, srcLine );
  *
  * @example
  * // returns false;
  * var srcLine =  [ -1, -1, -1, 0, 0, 1 ]
  * var srcCapsule = [ 0, 1, 0, 2, 2, 2, 0.5 ]
  * _.lineIntersects( srcCapsule, srcLine );
  *
  * @returns { Boolean } Returns true if the capsule and the line intersect.
  * @function lineIntersects
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcLine ) is not line.
  * @throws { Error } An Error if ( dim ) is different than line.dimGet (the capsule and line don´t have the same dimension).
  * @memberof wTools.capsule
  */
function lineIntersects( srcCapsule, srcLine )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let srcLineView = _.line._from( srcLine );
  let lineOrigin = _.line.originGet( srcLineView );
  let lineDirection = _.line.directionGet( srcLineView );
  let dimLine  = _.line.dimGet( srcLineView );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( dimLine );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  _.assert( dimCapsule === dimLine );

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.lineDistance( srcSegment, srcLineView );

  if( distance <= radius )
  { return true; }

  return false;

}

//

/**
  * Get the distance between a line and a capsule. Returns the calculated distance.
  * The capsule and the line remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcLine - Test line.
  *
  * @example
  * // returns 0;
  * _.lineDistance( [ 0, 0, 0, 2, 2, 2, 1 ], [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns Math.sqrt( 8 ) - 1;
  * _.lineDistance( [ 0, 0, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 0, 0, 1 ]);
  *
  * @returns { Number } Returns the distance between a capsule and a line.
  * @function lineDistance
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcLine ) is not line.
  * @throws { Error } An Error if ( dim ) is different than line.dimGet (the capsule and line don´t have the same dimension).
  * @memberof wTools.capsule
  */
function lineDistance( srcCapsule, srcLine )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcLine.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let srcLineView = _.line._from( srcLine );
  let lineOrigin = _.line.originGet( srcLineView );
  let lineDirection = _.line.directionGet( srcLineView );
  let lineDim  = _.line.dimGet( srcLineView );

  _.assert( dimCapsule === lineDim );

  if( _.capsule.lineIntersects( srcCapsuleView, srcLineView ) === true )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.lineDistance( srcSegment, srcLineView );

  return distance - radius;
}

//

/**
  * Get the closest point in a capsule to a line. Returns the calculated point.
  * The capsule and line remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcLine - Test line.
  *
  * @example
  * // returns 0;
  * _.lineClosestPoint( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns [ 0.5, 0, 0 ];
  * _.lineClosestPoint( [ 0, 0, 0, 0, 1, 0, 0.5 ] , [ 1, 0, 0, 1, 0, 0 ]);
  *
  * @returns { Array } Returns the closest point in the srcCapsule to the srcLine.
  * @function lineClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcLine ) is not line.
  * @throws { Error } An Error if ( dim ) is different than line.dimGet (the capsule and line don´t have the same dimension).
  * @memberof wTools.capsule
  */
function lineClosestPoint( srcCapsule, srcLine, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( srcLine.length / 2 );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcLine.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let srcLineView = _.line._from( srcLine );
  let lineOrigin = _.line.originGet( srcLineView );
  let tstDir = _.line.directionGet( srcLineView );
  let lineDim = _.line.dimGet( srcLineView );

  let dstPointView = _.vector.from( dstPoint );
  _.assert( dimCapsule === lineDim );

  if( _.capsule.lineIntersects( srcCapsuleView, srcLineView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let center = _.segment.lineClosestPoint( srcSegment, srcLineView );
  let sphere = _.sphere.make( lineDim );
  _.sphere.fromCenterAndRadius( sphere, center, radius );
  let point =_.sphere.lineClosestPoint( sphere, srcLineView );

  let pointView = _.vector.from( point );
  for( let i = 0; i < pointView.length; i++ )
  {
    dstPointView.eSet( i, pointView.eGet( i ) );
  }

  return dstPoint;
}

//

/**
  * Check if a capsule and a plane intersect. Returns true if they intersect and false if not.
  * The plane and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcPlane - Source plane.
  *
  * @example
  * // returns true;
  * _.planeIntersects( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 1, 0, 0, - 1 ]);
  *
  * @example
  * // returns false;
  * _.planeIntersects( [ 0, -1, 0, 0, -2, 0, 0.5 ] , [ 1, 0, 0, - 1 ]);
  *
  * @returns { Boolean } Returns true if the capsule and the plane intersect.
  * @function planeIntersects
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcPlane ) is not plane.
  * @throws { Error } An Error if ( dim ) is different than plane.dimGet (the capsule and plane don´t have the same dimension).
  * @memberof wTools.capsule
  */
function planeIntersects( srcCapsule, srcPlane )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcPlane.length - 1 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let planeView = _.plane._from( srcPlane );
  let normal = _.plane.normalGet( planeView );
  let bias = _.plane.biasGet( planeView );
  let dimPlane = _.plane.dimGet( planeView );

  _.assert( dimCapsule === dimPlane );

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.planeDistance( srcSegment, planeView );

  if( distance <= radius )
  { return true; }

  return false;
}

//

/**
  * Get the distance between a capsule and a plane. Returns the calculated distance.
  * The plane and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcPlane - Source plane.
  *
  * @example
  * // returns 0;
  * _.planeDistance( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 1, 0, 0, - 1 ]);
  *
  * @example
  * // returns 0.5;
  * _.planeDistance( [ 0, -1, 0, 0, -2, 0, 0.5 ] , [ 1, 0, 0, - 1 ]);
  *
  * @returns { Number } Returns the distance between the capsule and the plane.
  * @function planeDistance
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcPlane ) is not plane.
  * @throws { Error } An Error if ( dim ) is different than plane.dimGet (the capsule and plane don´t have the same dimension).
  * @memberof wTools.capsule
  */
function planeDistance( srcCapsule, srcPlane )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcPlane.length - 1 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let planeView = _.plane._from( srcPlane );
  let normal = _.plane.normalGet( planeView );
  let bias = _.plane.biasGet( planeView );
  let dimPlane = _.plane.dimGet( planeView );

  _.assert( dimCapsule === dimPlane );

  if( _.capsule.planeIntersects( srcCapsuleView, planeView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.planeDistance( srcSegment, planeView );

  return distance - radius;
}

//

/**
  * Get the closest point between a capsule and a plane. Returns the calculated point.
  * The plane and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcPlane - Source plane.
  * @param { Array } dstPoint - Destination point.
  *
  * @example
  * // returns 0;
  * _.planeClosestPoint( [ 0, 0, 0, 2, 2, 2, 1 ] , [ 1, 0, 0, - 1 ]);
  *
  * @example
  * // returns [ 0, -0.5, 0 ];
  * _.planeClosestPoint( [ 0, -1, 0, 0, -2, 0, 0.5 ] , [ 1, 0, 0, - 1 ]);
  *
  * @returns { Array } Returns the closest point in the capsule to the plane.
  * @function planeClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcPlane ) is not plane.
  * @throws { Error } An Error if ( dim ) is different than plane.dimGet (the capsule and plane don´t have the same dimension).
  * @memberof wTools.capsule
  */
function planeClosestPoint( srcCapsule, srcPlane, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( srcPlane.length - 1 );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcPlane.length - 1 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let planeView = _.plane._from( srcPlane );
  let normal = _.plane.normalGet( planeView );
  let bias = _.plane.biasGet( planeView );
  let dimPlane = _.plane.dimGet( planeView );

  let dstPointView = _.vector.from( dstPoint );

  _.assert( dimCapsule === dimPlane );
  if( _.capsule.planeIntersects( srcCapsuleView, planeView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let center = _.segment.planeClosestPoint( srcSegment, planeView );
  let sphere = _.sphere.make( dimPlane );
  _.sphere.fromCenterAndRadius( sphere, center, radius );
  let point =_.sphere.planeClosestPoint( sphere, planeView );

  let pointView = _.vector.from( point );
  for( let i = 0; i < pointView.length; i++ )
  {
    dstPointView.eSet( i, pointView.eGet( i ) );
  }

  return dstPoint;

}

//

/**
  * Check if a capsule and a ray intersect. Returns true if they intersect and false if not.
  * The ray and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcRay - Source ray.
  *
  * @example
  * // returns true;
  * var srcRay =  [ -1, -1, -1, 1, 1, 1 ]
  * var srcCapsule = [ 0, 0, 0, 2, 2, 2, 1 ]
  * _.rayIntersects( srcCapsule, srcRay );
  *
  * @example
  * // returns false;
  * var srcRay =  [ -1, -1, -1, 0, 0, 1 ]
  * var srcCapsule = [ 0, 1, 0, 2, 2, 2, 0.5 ]
  * _.rayIntersects( srcCapsule, srcRay );
  *
  * @returns { Boolean } Returns true if the capsule and the ray intersect.
  * @function rayIntersects
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcRay ) is not ray.
  * @throws { Error } An Error if ( dim ) is different than ray.dimGet (the capsule and ray don´t have the same dimension).
  * @memberof wTools.capsule
  */
function rayIntersects( srcCapsule, srcRay )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let srcRayView = _.ray._from( srcRay );
  let rayOrigin = _.ray.originGet( srcRayView );
  let rayDirection = _.ray.directionGet( srcRayView );
  let dimRay  = _.ray.dimGet( srcRayView );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcRay.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  _.assert( dimCapsule === dimRay );

  let srcSegment = _.segment.fromPair( [ origin, end ] );
  let distance = _.segment.rayDistance( srcSegment, srcRayView );

  if( distance <= radius )
  { return true; }

  return false;
}

//

/**
  * Get the distance between a ray and a capsule. Returns the calculated distance.
  * The capsule and the ray remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcRay - Test ray.
  *
  * @example
  * // returns 0;
  * _.rayDistance( [ 0, 0, 0, 2, 2, 2, 1 ], [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns Math.sqrt( 12 ) - 1;
  * _.rayDistance( [ 0, 0, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 0, 0, 1 ]);
  *
  * @returns { Number } Returns the distance between a capsule and a ray.
  * @function rayDistance
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcRay ) is not ray.
  * @throws { Error } An Error if ( dim ) is different than ray.dimGet (the capsule and ray don´t have the same dimension).
  * @memberof wTools.capsule
  */
function rayDistance( srcCapsule, srcRay )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcRay.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let srcRayView = _.ray._from( srcRay );
  let rayOrigin = _.ray.originGet( srcRayView );
  let rayDirection = _.ray.directionGet( srcRayView );
  let dimRay  = _.ray.dimGet( srcRayView );

  _.assert( dimCapsule === dimRay );

  if( _.capsule.rayIntersects( srcCapsuleView, srcRayView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.rayDistance( srcSegment, srcRayView );

  return distance - radius;
}

//

/**
  * Get the closest point in a capsule to a ray. Returns the calculated point.
  * The capsule and ray remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcRay - Test ray.
  *
  * @example
  * // returns 0;
  * _.rayClosestPoint( [ 0, 0, 0, 2, 2, 2, 0 ] , [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns [ -1, 0, 0 ];
  * _.rayClosestPoint( [ 0, 0, 0, 1, 0, 0, 1 ] , [ -2, 0, 0, -1, 0, 0 ]);
  *
  * @returns { Array } Returns the closest point in the srcCapsule to the srcRay.
  * @function rayClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcRay ) is not ray.
  * @throws { Error } An Error if ( dim ) is different than ray.dimGet (the capsule and ray don´t have the same dimension).
  * @memberof wTools.capsule
  */
function rayClosestPoint( srcCapsule, srcRay, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( srcRay.length / 2 );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcRay.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let srcRayView = _.ray._from( srcRay );
  let rayOrigin = _.ray.originGet( srcRayView );
  let tstDir = _.ray.directionGet( srcRayView );
  let dimRay = _.ray.dimGet( srcRayView );

  let dstPointView = _.vector.from( dstPoint );

  _.assert( dimCapsule === dimRay );

  if( _.capsule.rayIntersects( srcCapsuleView, srcRayView ) )
  return 0;

  let srcSegment = _.segment.fromPair( [ origin, end ] );

  let center = _.segment.rayClosestPoint( srcSegment, srcRayView );
  let sphere = _.sphere.make( dimRay );
  _.sphere.fromCenterAndRadius( sphere, center, radius );
  let point =_.sphere.rayClosestPoint( sphere, srcRayView );

  let pointView = _.vector.from( point );
  for( let i = 0; i < pointView.length; i++ )
  {
    dstPointView.eSet( i, pointView.eGet( i ) );
  }

  return dstPoint;
}

//

/**
  *Check if the source capsule contains the test segment. Returns true if it is contained, false if not.
  * Capsule and segment are stored in Array data structure and remain unchanged
  *
  * @param { Array } srcCapsule - The source capsule (container).
  * @param { Array } tstSegment - The tested segment (the segment to check if it is contained in srcCapsule).
  *
  * @example
  * // returns true
  * _.segmentContains( [ 0, 0, 0, 2, 2, 2, 1 ], [ 1, 1, 1, 2, 1, 1 ] );
  *
  * @example
  * // returns false
  * _.segmentContains( [ 0, 0, 0, 2, 2, 2, 0.1 ], [ 0, 0, 1, 1, 1, 2.5 ] );
  *
  * @returns { Boolean } Returns true if the segment is contained and false if not.
  * @function segmentContains
  * @throws { Error } An Error if ( dim ) is different than dimGet(capsule) (the capsule and segment don´t have the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule
  * @throws { Error } An Error if ( tstSegment ) is not segment
  * @memberof wTools.capsule
  */

function segmentContains( srcCapsule , tstSegment )
{

  let segmentView = _.segment._from( tstSegment );
  let origin = _.segment.originGet( segmentView );
  let end = _.segment.endPointGet( segmentView );
  let dimS = _.segment.dimGet( segmentView );

  let capsuleView = _.capsule._from( srcCapsule );
  let dimC = _.capsule.dimGet( capsuleView );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( dimS === dimC );

  if( !_.capsule.pointContains( capsuleView, origin ) )
  return false;

  if( !_.capsule.pointContains( capsuleView, end ) )
  return false;

  return true;
}

//

/**
  * Check if a capsule and a segment intersect. Returns true if they intersect and false if not.
  * The segment and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcSegment - Source segment.
  *
  * @example
  * // returns true;
  * var srcSegment =  [ -1, -1, -1, 1, 1, 1 ]
  * var srcCapsule = [ 0, 0, 0, 2, 2, 2, 1 ]
  * _.segmentIntersects( srcCapsule, srcSegment );
  *
  * @example
  * // returns false;
  * var srcSegment =  [ -1, -1, -1, 0, 0, 1 ]
  * var srcCapsule = [ 0, 1, 0, 2, 2, 2, 0.5 ]
  * _.segmentIntersects( srcCapsule, srcSegment );
  *
  * @returns { Boolean } Returns true if the capsule and the segment intersect.
  * @function segmentIntersects
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcSegment ) is not segment.
  * @throws { Error } An Error if ( dim ) is different than segment.dimGet (the capsule and segment don´t have the same dimension).
  * @memberof wTools.capsule
  */
function segmentIntersects( srcCapsule, srcSegment )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let srcSegmentView = _.segment._from( srcSegment );
  let dimSegment  = _.segment.dimGet( srcSegmentView );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcSegment.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  _.assert( dimCapsule === dimSegment );

  let srcSegmentCapsule = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.segmentDistance( srcSegmentCapsule, srcSegmentView );

  if( distance <= radius )
  { return true; }

  return false;
}

//

/**
  * Get the distance between a segment and a capsule. Returns the calculated distance.
  * The capsule and the segment remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcSegment - Test segment.
  *
  * @example
  * // returns 0;
  * _.segmentDistance( [ 0, 0, 0, 2, 2, 2, 1 ], [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns Math.sqrt( 12 ) - 1;
  * _.segmentDistance( [ 0, 0, 0, 0, -2, 0, 1 ] , [ 2, 2, 2, 0, 0, 1 ]);
  *
  * @returns { Number } Returns the distance between a capsule and a segment.
  * @function segmentDistance
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcSegment ) is not segment.
  * @throws { Error } An Error if ( dim ) is different than segment.dimGet (the capsule and segment don´t have the same dimension).
  * @memberof wTools.capsule
  */
function segmentDistance( srcCapsule, srcSegment )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcSegment.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let srcSegmentView = _.segment._from( srcSegment );
  let dimSegment  = _.segment.dimGet( srcSegmentView );

  _.assert( dimCapsule === dimSegment );

  if( _.capsule.segmentIntersects( srcCapsuleView, srcSegmentView ) )
  return 0;

  let srcSegmentCapsule = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.segmentDistance( srcSegmentCapsule, srcSegmentView );

  return distance - radius;
}

//

/**
  * Get the closest point in a capsule to a segment. Returns the calculated point.
  * The capsule and segment remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcSegment - Test segment.
  *
  * @example
  * // returns 0;
  * _.segmentClosestPoint( [ 0, 0, 0, 2, 2, 2, 0 ] , [ 0, 0, 0, 1, 1, 1 ]);
  *
  * @example
  * // returns [ -1, 0, 0 ];
  * _.segmentClosestPoint( [ 0, 0, 0, 1, 0, 0, 1 ] , [ -2, 0, 0, -1, 0, 0 ]);
  *
  * @returns { Arsegment } Returns the closest point in the srcCapsule to the srcSegment.
  * @function segmentClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcSegment ) is not segment.
  * @throws { Error } An Error if ( dim ) is different than segment.dimGet (the capsule and segment don´t have the same dimension).
  * @memberof wTools.capsule
  */
function segmentClosestPoint( srcCapsule, srcSegment, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( srcSegment.length / 2 );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcSegment.length / 2 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let srcSegmentView = _.segment._from( srcSegment );
  let dimSegment = _.segment.dimGet( srcSegmentView );

  let dstPointView = _.vector.from( dstPoint );

  _.assert( dimCapsule === dimSegment );

  if( _.capsule.segmentIntersects( srcCapsuleView, srcSegmentView ) )
  return 0;

  let srcSegmentCapsule = _.segment.fromPair( [ origin, end ] );

  let center = _.segment.segmentClosestPoint( srcSegmentCapsule, srcSegmentView );
  let sphere = _.sphere.make( dimSegment );
  _.sphere.fromCenterAndRadius( sphere, center, radius );
  let point =_.sphere.segmentClosestPoint( sphere, srcSegmentView );

  let pointView = _.vector.from( point );
  for( let i = 0; i < pointView.length; i++ )
  {
    dstPointView.eSet( i, pointView.eGet( i ) );
  }

  return dstPoint;
}

//

/**
  *Check if the source capsule contains test sphere. Returns true if it is contained, false if not.
  * Capsule and sphere are stored in Array data structure and remain unchanged
  *
  * @param { Array } srcCapsule - The source capsule (container).
  * @param { Array } tstSphere - The tested sphere (the sphere to check if it is contained in srcCapsule).
  *
  * @example
  * // returns true
  * _.sphereContains( [ 0, 0, 0, 2, 2, 2 ], [ 1, 1, 1, 1 ] );
  *
  * @example
  * // returns false
  * _.sphereContains( [ 0, 0, 0, 2, 2, 2 ], [ 0, 0, 1, 2.5 ] );
  *
  * @returns { Boolean } Returns true if the sphere is contained and false if not.
  * @function sphereContains
  * @throws { Error } An Error if ( dim ) is different than dimGet(capsule) (the capsule and sphere don´t have the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule
  * @throws { Error } An Error if ( tstSphere ) is not sphere
  * @memberof wTools.capsule
  */

function sphereContains( srcCapsule , tstSphere )
{
  let tstSphereView = _.sphere._from( tstSphere );
  let center = _.sphere.centerGet( tstSphereView );
  let radius = _.sphere.radiusGet( tstSphereView );
  let dimS = _.sphere.dimGet( tstSphereView );

  let capsuleView = _.capsule._from( srcCapsule );
  let dimC = _.capsule.dimGet( capsuleView );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( dimS === dimC );

  let pointp = _.vector.from( center.slice() );
  let pointn = _.vector.from( center.slice() );
  for( let i = 0; i < dimS; i++ )
  {
    pointp.eSet( i, pointp.eGet( i ) + radius );
    pointn.eSet( i, pointn.eGet( i ) - radius );

    if( !_.capsule.pointContains( capsuleView, pointp ) )
    return false;

    if( !_.capsule.pointContains( capsuleView, pointn ) )
    return false;

    pointp.eSet( i, pointp.eGet( i ) - radius );
    pointn.eSet( i, pointn.eGet( i ) + radius );
  }

  return true;
}

//

/**
  * Check if a capsule and a sphere intersect. Returns true if they intersect and false if not.
  * The sphere and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcSphere - Source sphere.
  *
  * @example
  * // returns true;
  * _.sphereIntersects( [ 0, 0, 0, 2, 2, 2, 1 ], [ 0, 0, 0, 1 ]);
  *
  * @example
  * // returns false;
  * _.sphereIntersects( [ 0, 0, 0, 0, -2, 0, 1 ], [ 3, 3, 3, 1 ]);
  *
  * @returns { Boolean } Returns true if the capsule and the sphere intersect.
  * @function sphereIntersects
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcSphere ) is not sphere.
  * @throws { Error } An Error if ( dim ) is different than sphere.dimGet (the capsule and sphere don´t have the same dimension).
  * @memberof wTools.capsule
  */
function sphereIntersects( srcCapsule, srcSphere )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.sphere.is( srcSphere ) );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcSphere.length - 1 );

  let sphereView = _.sphere._from( srcSphere );
  let dimSphere = _.sphere.dimGet( sphereView );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  _.assert( dimCapsule === dimSphere );

  let srcSegmentCapsule = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.sphereDistance( srcSegmentCapsule, sphereView );

  if( distance <= radius )
  { return true; }

  return false;

}

//

/**
  * Get the distance between a capsule and a sphere. Returns the calculated distance.
  * The sphere and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcSphere - Source sphere.
  *
  * @example
  * // returns 0;
  * _.sphereDistance( [ 0, 0, 0, 2, 2, 2, 1 ], [ 0, 0, 0, 1 ]);
  *
  * @example
  * // returns Math.sqrt( 27 ) - 2;
  * _.sphereDistance( [ 0, 0, 0, 0, -2, 0, 1 ], [ 3, 3, 3, 1 ]);
  *
  * @returns { Boolean } Returns the distance between the capsule and the sphere.
  * @function sphereDistance
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcSphere ) is not sphere.
  * @throws { Error } An Error if ( dim ) is different than sphere.dimGet (the capsule and sphere don´t have the same dimension).
  * @memberof wTools.capsule
  */
function sphereDistance( srcCapsule, srcSphere )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.sphere.is( srcSphere ) );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcSphere.length - 1 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let sphereView = _.sphere._from( srcSphere );
  let dimSphere = _.sphere.dimGet( sphereView );

  _.assert( dimCapsule === dimSphere );

  if( _.capsule.sphereIntersects( srcCapsuleView, sphereView ) )
  return 0;

  let srcSegmentCapsule = _.segment.fromPair( [ origin, end ] );

  let distance = _.segment.sphereDistance( srcSegmentCapsule, sphereView );

  return distance - radius;
}

//

/**
  * Get the closest point in a capsule to a sphere. Returns the calculated point.
  * The sphere and the capsule remain unchanged.
  *
  * @param { Array } srcCapsule - Source capsule.
  * @param { Array } srcSphere - Source sphere.
  * @param { Array } dstPoint - Destination point.
  *
  * @example
  * // returns 0;
  * _.sphereClosestPoint( [ 0, 0, 0, 2, 2, 2, 1 ], [ 0, 0, 0, 1 ]);
  *
  * @example
  * // returns [ 1, 1, 1 ];
  * _.sphereClosestPoint( [ 0, 0, 0, 0, -2, 0, Math.sqrt( 3 ) ], [ 3, 3, 3, 1 ]);
  *
  * @returns { Boolean } Returns the closest point in a capsule to a sphere.
  * @function sphereClosestPoint
  * @throws { Error } An Error if ( arguments.length ) is different than two or three.
  * @throws { Error } An Error if ( srcCapsule ) is not capsule.
  * @throws { Error } An Error if ( srcSphere ) is not sphere.
  * @throws { Error } An Error if ( dim ) is different than sphere.dimGet (the capsule and sphere don´t have the same dimension).
  * @memberof wTools.capsule
  */
function sphereClosestPoint( srcCapsule, srcSphere, dstPoint )
{
  _.assert( arguments.length === 2 || arguments.length === 3 , 'Expects two or three arguments' );
  _.assert( _.sphere.is( srcSphere ) );

  if( arguments.length === 2 )
  dstPoint = _.array.makeArrayOfLength( srcSphere.length - 1 );

  if( dstPoint === null || dstPoint === undefined )
  throw _.err( 'Not a valid destination point' );

  if( srcCapsule === null )
  srcCapsule = _.capsule.make( srcSphere.length - 1 );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radius = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radius >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  let sphereView = _.sphere._from( srcSphere );
  let dimSphere = _.sphere.dimGet( sphereView );

  let dstPointView = _.vector.from( dstPoint );

  _.assert( dimCapsule === dimSphere );

  if( _.capsule.sphereIntersects( srcCapsuleView, sphereView ) )
  return 0;

  let srcSegmentCapsule = _.segment.fromPair( [ origin, end ] );

  let center = _.segment.sphereClosestPoint( srcSegmentCapsule, sphereView );
  let sphere = _.sphere.make( dimSphere );
  _.sphere.fromCenterAndRadius( sphere, center, radius );
  let point =_.sphere.sphereClosestPoint( sphere, sphereView );

  let pointView = _.vector.from( point );
  for( let i = 0; i < pointView.length; i++ )
  {
    dstPointView.eSet( i, pointView.eGet( i ) );
  }

  return dstPoint;
}

//

/**
  * Get the bounding sphere of a capsule. Returns destination sphere.
  * Capsule and sphere are stored in Array data structure. Source capsule stays untouched.
  *
  * @param { Array } dstSphere - destination sphere.
  * @param { Array } srcCapsule - source capsule for the bounding sphere.
  *
  * @example
  * // returns [ 1, 1, 1, Math.sqrt( 3 ) + 1 ]
  * _.boundingSphereGet( null, [ 0, 0, 0, 2, 2, 2, 1 ] );
  *
  * @returns { Array } Returns the array of the bounding sphere.
  * @function boundingSphereGet
  * @throws { Error } An Error if ( dim ) is different than dimGet(capsule) (the capsule and the sphere don´t have the same dimension).
  * @throws { Error } An Error if ( arguments.length ) is different than two.
  * @throws { Error } An Error if ( dstSphere ) is not sphere
  * @throws { Error } An Error if ( srcCapsule ) is not capsule
  * @memberof wTools.capsule
  */
function boundingSphereGet( dstSphere, srcCapsule )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let srcCapsuleView = _.capsule._from( srcCapsule );
  let origin = _.capsule.originGet( srcCapsuleView );
  let end = _.capsule.endPointGet( srcCapsuleView );
  let radiusCapsule = _.capsule.radiusGet( srcCapsuleView );
  _.assert( radiusCapsule >= 0 );
  let dimCapsule  = _.capsule.dimGet( srcCapsuleView );

  if( dstSphere === null || dstSphere === undefined )
  dstSphere = _.sphere.makeZero( dimCapsule );

  _.assert( _.sphere.is( dstSphere ) );
  let dstSphereView = _.sphere._from( dstSphere );
  let center = _.sphere.centerGet( dstSphereView );
  let radiusSphere = _.sphere.radiusGet( dstSphereView );
  let dimSphere = _.sphere.dimGet( dstSphereView );

  _.assert( dimCapsule === dimSphere );

  // Center of the sphere
  for( let c = 0; c < center.length; c++ )
  {
    center.eSet( c, ( end.eGet( c ) + origin.eGet( c ) ) / 2 );
  }

  // Radius of the sphere
  _.sphere.radiusSet( dstSphereView, vector.distance( center, end )  + radiusCapsule );

  return dstSphere;
}




// --
// define class
// --

let Proto =
{

  make : make,
  makeZero : makeZero,
  makeNil : makeNil,

  zero : zero,
  nil : nil,

  from : from,
  _from : _from,

  is : is,
  dimGet : dimGet,
  originGet : originGet,
  endPointGet : endPointGet,
  radiusGet : radiusGet,
  radiusSet : radiusSet,

  expand : expand,
  project : project,
  getProjectionFactors : getProjectionFactors,

  pointContains : pointContains,
  pointDistance : pointDistance,
  pointClosestPoint : pointClosestPoint,

  boxContains : boxContains,
  boxIntersects : boxIntersects,
  boxDistance : boxDistance,
  boxClosestPoint : boxClosestPoint,
  boundingBoxGet : boundingBoxGet,

  capsuleContains : capsuleContains,
  capsuleIntersects : capsuleIntersects,
  capsuleDistance : capsuleDistance,
  capsuleClosestPoint : capsuleClosestPoint,

  convexPolygonContains : convexPolygonContains,
  convexPolygonIntersects : convexPolygonIntersects,
  convexPolygonDistance : convexPolygonDistance,
  convexPolygonClosestPoint : convexPolygonClosestPoint,

  frustumContains : frustumContains,
  frustumIntersects : frustumIntersects,
  frustumDistance : frustumDistance,
  frustumClosestPoint : frustumClosestPoint,

  lineIntersects : lineIntersects,
  lineDistance : lineDistance,
  lineClosestPoint : lineClosestPoint,

  planeIntersects : planeIntersects,
  planeDistance : planeDistance,
  planeClosestPoint : planeClosestPoint,

  rayIntersects : rayIntersects,
  rayDistance : rayDistance,
  rayClosestPoint : rayClosestPoint,

  segmentContains : segmentContains,
  segmentIntersects : segmentIntersects,
  segmentDistance : segmentDistance,
  segmentClosestPoint : segmentClosestPoint,

  sphereContains : sphereContains,
  sphereIntersects : sphereIntersects,
  sphereDistance : sphereDistance,
  sphereClosestPoint : sphereClosestPoint,
  boundingSphereGet : boundingSphereGet,


}

_.mapSupplement( Self, Proto );

//

if( typeof module !== 'undefined' )
{

  // require( './Sphere.s' );

}

})();
