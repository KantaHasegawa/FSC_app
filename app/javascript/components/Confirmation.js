import React from "react"
import PropTypes from "prop-types"

class Confirmation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      email: '',
      email_error: true,
    };
  }

  handleEmailChange(event) {
    const inputValue = event.target.value;
    this.setState({
      email: inputValue
    });
    if (inputValue === '') {
      this.setState({
        email_error: true,
      });
    } else {
      this.setState({
        email_error: false,
      });
    }
  }

  render() {

    let emailErrorText;
    if (this.state.email_error) {
      emailErrorText = (
        <div className="dynamic_error_message">※メールアドレスが入力されていません</div>
      );
    } else {
      emailErrorText = '';
    }


    return (
      <form className="new_user" action="/users/confirmation" accept-charset="UTF-8" method="post">
        <input type="hidden" name="authenticity_token" value={this.props.token} />

        <div className="field">
          <input
            value={this.state.email}
            onChange={(event) => { this.handleEmailChange(event) }}
            placeholder="メールアドレスを入力してください"
            className="form-control" type="email" name="user[email]"/>
        </div>
        {emailErrorText}

        <div className="action">
          <input
            disabled={this.state.email_error}
            type="submit" name="commit" value="送信する" className="btn  btn-primary btn-block"/>
        </div>
      </form>
    );
  }
}

export default Confirmation
