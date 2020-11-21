import React from "react"
import PropTypes from "prop-types"

class NewPassword extends React.Component {
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
        <div class="dynamic_error_message">※メールアドレスが入力されていません</div>
      );
    } else {
      emailErrorText = '';
    }


    return (
      <form class="new_user" id="new_user" action="/users/password" accept-charset="UTF-8" method="post">
        <input type="hidden" name="authenticity_token" value={this.props.token} />

        <div class="field">
          <input
            value={this.state.email}
            onChange={(event) => { this.handleEmailChange(event) }}
            placeholder="メールアドレスを入力してください"
            autofocus="autofocus" class="form-control" autocomplete="email" type="email" name="user[email]" id="user_email" />
        </div>
        {emailErrorText}

        <div class="action">
          <input
            disabled={this.state.email_error || this.state.password_error}
            type="submit" name="commit" value="送信する" class="btn  btn-primary btn-block" data-disable-with="送信する" />
        </div>
      </form>
    );
  }
}

export default NewPassword
