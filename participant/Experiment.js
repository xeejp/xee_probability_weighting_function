import React, { Component } from 'react'
import { connect } from 'react-redux'

import {RadioButton, RadioButtonGroup} from 'material-ui/RadioButton'
import {Card, CardText, CardTitle } from 'material-ui/Card'
import RaisedButton from 'material-ui/RaisedButton'
import SwipeableViews from 'react-swipeable-views'
import Question from './Question'
import Result from './Result'

import { Start } from './actions'

const mapStateToProps = ({ money,unit,ansed,question,state}) => ({
  money,unit,ansed,question,state
})

class Experiment extends Component {
  constructor(props) {
    super(props)
  }

	start(){
		const { dispatch } = this.props
		dispatch(Start())
	}
  
  render() {
    const { money,unit,ansed,question,state} = this.props
		console.log(state)
    switch (state){
		case 0:
			return (
				<Card>
					<CardTitle title="確率加重関数の推定" subtitle="ルールの説明" />
					<CardText>
						<p>いくつかの二択の質問に答えてもらいます</p>
						<p>OKを押すと実験が始まります</p> <br/>
						<RaisedButton onClick = {this.start.bind(this)} style ={{textAlign: "center"}} primary={true} >OK</RaisedButton>
					</CardText>
				</Card>
			)
    case 1:
      return (<Card><CardText><Question /></CardText></Card>)
		case 2:
			return (<Result />)
    }
  }
}

export default connect(mapStateToProps)(Experiment)
