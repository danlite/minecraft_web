import { connect } from 'react-redux'
import React from 'react'

function mapStateToProps(state) {
  return {
    $$maps: state.$$mapStore.get('maps'),
    pois: [
      { x: -336, z: 128 },
      { x: -336, z: 159 },
      { x: -305, z: 128 },
      { x: -305, z: 159 },

      { x: -112, z: 400 },
      { x: -112, z: 415 },
      { x: -65, z: 400 },
      { x: -65, z: 415 },

      { x: -112, z: 560 },
      { x: -112, z: 591 },
      { x: -97, z: 560 },
      { x: -97, z: 591 },

      { x: -71, z: 636 },

      { x: 537, z: 2080 }
    ]
  }
}

function edgesForMaps($$maps) {
  const maximumX = $$maps.reduce((max, $$map) => {
    return Math.max(max, $$map.get('center_x') + $$map.get('width') / 2 * Math.pow(2, $$map.get('scale')))
  }, Number.MIN_SAFE_INTEGER)

  const minimumX = $$maps.reduce((min, $$map) => {
    return Math.min(min, $$map.get('center_x') - $$map.get('width') / 2 * Math.pow(2, $$map.get('scale')))
  }, Number.MAX_SAFE_INTEGER)

  const maximumZ = $$maps.reduce((max, $$map) => {
    return Math.max(max, $$map.get('center_z') + $$map.get('height') / 2 * Math.pow(2, $$map.get('scale')))
  }, Number.MIN_SAFE_INTEGER)

  const minimumZ = $$maps.reduce((min, $$map) => {
    return Math.min(min, $$map.get('center_z') - $$map.get('height') / 2 * Math.pow(2, $$map.get('scale')))
  }, Number.MAX_SAFE_INTEGER)

  return {
    minimumX,
    maximumX,
    minimumZ,
    maximumZ
  }
}

const Maps = ({ $$maps, pois }) => {
  const { minimumX, maximumX, minimumZ, maximumZ } = edgesForMaps($$maps)
  const containerDimensions = {
    width: maximumX - minimumX,
    height: maximumZ - minimumZ
  }

  return <div className="maps-container" style={Object.assign({}, containerDimensions)}>
    {$$maps.map($$map => (
      <div  key={$$map.get('id')}
            className="map"
            style={{
              top: $$map.get('center_z') - minimumZ,
              left: $$map.get('center_x') - minimumX,
              zIndex: 4 - $$map.get('scale')
            }}>
        <img src={$$map.getIn(['image', 'url'])}
             style={{ transform: `scale(${Math.pow(2, $$map.get('scale'))}` }} />
      </div>
      )
    )}
    {pois.map(poi => (
      <div  className="poi"
            style={{
              top: poi.z - minimumZ,
              left: poi.x - minimumX
            }}
      />
    ))}
  </div>
}

export default connect(mapStateToProps)(Maps)
