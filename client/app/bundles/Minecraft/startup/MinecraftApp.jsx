import React from 'react'
import { Provider } from 'react-redux'
import { Router, Route, IndexRoute, browserHistory } from 'react-router'

import createStore from '../store/minecraftStore'
import Maps from '../containers/Maps'

export default (props) => {
  const store = createStore(props)

  const reactComponent = (
    <Provider store={store}>
      <Router history={browserHistory}>
        <Route path="/maps" component={Maps} />
      </Router>
    </Provider>
  )
  return reactComponent
}
