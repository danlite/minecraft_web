import Immutable from 'immutable'

export const $$initialState = Immutable.fromJS({ maps: [] })

export default (state = $$initialState) => state
