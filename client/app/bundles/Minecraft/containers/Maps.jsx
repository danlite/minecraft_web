import { connect } from 'react-redux'
import React from 'react'

function mapStateToProps(state) {
  return {
    $$maps: state.$$mapStore.get('maps')
  }
}

const Maps = ({ $$maps }) => (
  <div>
    {$$maps.map($$map => <div key={$$map.get('id')}><img src={$$map.getIn(['image', 'url'])} /></div>)}
  </div>
)

export default connect(mapStateToProps)(Maps)
