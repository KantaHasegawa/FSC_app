import React from "react"
import PropTypes from "prop-types"

class SignIn extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      email: '',
      password: '',
      email_error: true,
      password_error: true,
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

  handlePasswordChange(event){
    const inputValue = event.target.value;
    this.setState({
      password: inputValue
    });
    if (inputValue === '') {
      this.setState({
        password_error: true,
      });
    } else {
      this.setState({
        password_error: false,
      })
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

    let passwordErrorText;
    if (this.state.password_error) {
      passwordErrorText = (
        <div class="dynamic_error_message">※パスワードが入力されていません</div>
      );
    } else {
      passwordErrorText = '';
    }

    return (
      <form class="new_user" id="new_user" action="/users/sign_in" accept-charset="UTF-8" method="post">
        <input type="hidden" name="authenticity_token" value={this.props.token} />

          <div class="field">
          <input
            value={this.state.email}
            onChange={(event) => { this.handleEmailChange(event) }}
            placeholder="メールアドレスを入力してください"
            autofocus="autofocus" class="form-control"  autocomplete="email" type="email" name="user[email]" id="user_email" />
          </div>
            {emailErrorText}
            <div class="field">
          <input
            value={this.state.password}
            onChange={(event) => { this.handlePasswordChange(event) }}
            placeholder="パスワードを入力してください"
            class="form-control" autocomplete="current-password" type="password" name="user[password]" id="user_password" />
            </div>
            {passwordErrorText}
            <div class="field">
              <input name="user[remember_me]" type="hidden" value="0" /><input type="checkbox" value="1" name="user[remember_me]" id="user_remember_me" />
                <label for="user_remember_me">ログインを記憶</label>
            </div>

            <div class="action">
          <input
            disabled={this.state.email_error || this.state.password_error}
            type="submit" name="commit" value="ログイン" class="btn btn-primary btn-block" data-disable-with="ログイン" />
            </div>
      </form>
    );
  }
}

export default SignIn
