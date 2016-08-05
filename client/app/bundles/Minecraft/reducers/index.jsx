import mapReducer from './mapReducer'
import { $$initialState as $$mapState } from './mapReducer'

export default {
  $$mapStore: mapReducer
}

export const initialStates = {
  $$mapState
}
