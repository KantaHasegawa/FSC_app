import React from "react"
import PropTypes from "prop-types"

class EditPassword extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      password: '',
      password_confirmation: '',
      password_error: true,
      password_confirmation_error: true,
    };
  }

  handlePasswordChange(event) {
    const inputValue = event.target.value;
    this.setState({
      password: inputValue
    });
    if (inputValue.length < 6) {
      this.setState({
        password_error: true,
      });
    } else {
      this.setState({
        password_error: false,
      })
    }
  }

  handlePassword_confirmationChange(event) {
    const inputValue = event.target.value;
    this.setState({
      password_confirmation: inputValue
    });
    if (inputValue === '' || inputValue != this.state.password) {
      this.setState({
        password_confirmation_error: true,
      });
    } else {
      this.setState({
        password_confirmation_error: false,
      })
    }
  }

  render() {

    let passwordErrorText;
    if (this.state.password_error) {
      if (this.state.password === '') {
        passwordErrorText = (
          <div class="dynamic_error_message">※パスワードが入力されていません</div>
        );
      } else {
        passwordErrorText = (
          <div class="dynamic_error_message">※パスワードは英数字6文字以上で入力してください</div>
          );}
    } else {
      passwordErrorText = '';
    }

    let password_confirmationErrorText;
    if (this.state.password_confirmation_error) {
      if (this.state.password_confirmation != this.state.password) {
        password_confirmationErrorText = (
          <div class="dynamic_error_message">※パスワードが一致しません</div>
        );
      } else {
        password_confirmationErrorText = (
          <div class="dynamic_error_message">※確認用パスワードが入力されていません</div>
        );
      }
    } else {
      password_confirmationErrorText = '';
    }


    return (
      <form class="new_user" id="new_user" action="/users/password" accept-charset="UTF-8" method="post">
        <input type="hidden" name="authenticity_token" value={this.props.token} />

        <div class="field">
          <input
            value={this.state.password}
            onChange={(event) => { this.handlePasswordChange(event) }}
            autocomplete="new-password" class="form-control" placeholder="英数字6文字以上でパスワードを入力してください" type="password" name="user[password]" id="user_password" />
        </div>
        {passwordErrorText}
        <div class="field">
          <input
            value={this.state.password_confirmation}
            onChange={(event) => { this.handlePassword_confirmationChange(event) }}autocomplete="new-password" class="form-control" placeholder="確認用パスワードを入力してください" type="password" name="user[password_confirmation]" id="user_password_confirmation" />
        </div>
        {password_confirmationErrorText}

        <div class="action">
          <input
            disabled={this.state.password_error || this.state.password_confirmation_error}
            type="submit" name="commit" value="パスワードを変更する" class="btn  btn-primary btn-block" data-disable-with="パスワードを変更する" />
        </div>
      </form>
    );
  }
}

export default EditPassword
