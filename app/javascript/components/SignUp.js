import React from "react"
import PropTypes from "prop-types"

class SignUp extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      email: '',
      password: '',
      participated_at: '',
      password_confirmation: '',
      email_error: true,
      password_error: true,
      participated_at_error: true,
      password_confirmation_error: true,
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

  handleParticipated_atChange(event) {
    const inputValue = event.target.value;
    this.setState({
      participated_at: inputValue
    });
    if (inputValue === '') {
      this.setState({
        participated_at_error: true,
      });
    } else {
      this.setState({
        participated_at_error: false,
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
      if (this.state.password === '') {
        passwordErrorText = (
          <div class="dynamic_error_message">※パスワードが入力されていません</div>
        );
      } else {
        passwordErrorText = (
          <div class="dynamic_error_message">※パスワードは英数字6文字以上で入力してください</div>
        );
      }
    } else {
      passwordErrorText = '';
    }

    let participated_atErrorText;
    if (this.state.participated_at_error) {
      participated_atErrorText = (
        <div class="dynamic_error_message">※入部年度が入力されていません</div>
      );
    } else {
      participated_atErrorText = '';
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
      <form class="new_user" id="new_user" action="/users/sign_in" enctype="multipart/form-data" accept-charset="UTF-8" method="post">
        <input type="hidden" name="authenticity_token" value={this.props.token} />

        <div class="field">
          <label for="user_image">プロフィール画像</label>
          <input type="file" accept="image/jpeg,image/png" name="user[image]" id="user_image" />
        </div>

        <div class="topandbottom5px">
          <div class="radio">
            <label htmlFor="user_gender_0">
              <input type="radio" value="0" name="user[gender]" checked="checked" id="user_gender_0" />
            男</label></div>
          <div class="radio">
            <label htmlFor="user_gender_1">
              <input type="radio" value="1" name="user[gender]" id="user_gender_1" />
            女</label></div>
        </div>

        <div class="field">
          <select class="form-control" name="user[main_part]" id="user_main_part"><option value="Vo">Vo</option>
            <option value="Gt">Gt</option>
            <option value="Ba">Ba</option>
            <option value="Dr">Dr</option>
            <option value="Key">Key</option></select>
        </div>

        <div class="field">
          <select class="form-control" name="user[roll]" id="user_roll"><option value="平部員">平部員</option>
            <option value="平部長">平部長</option>
            <option value="幹事">幹事</option>
            <option value="会計">会計</option>
            <option value="渉外">渉外</option>
            <option value="機材">機材</option>
            <option value="部長">部長</option>
            <option value="副部長">副部長</option>
            <option value="次期部長">次期部長</option>
            <option value="次期副部長">次期副部長</option></select>
        </div>

        <div class="field">
          <input
            value={this.state.participated_at}
            onChange={(event) => { this.handleParticipated_atChange(event) }}
            autofocus="autofocus" class="form-control" placeholder="入部した年を入力してください" type="number" name="user[participated_at]" id="user_participated_at" />
        </div>
        {participated_atErrorText}

        <div class="field">
          <input
            value={this.state.email}
            onChange={(event) => { this.handleEmailChange(event) }}
            placeholder="メールアドレスを入力してください"
            autofocus="autofocus" class="form-control" autocomplete="email" type="email" name="user[email]" id="user_email" />
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
          <input
            value={this.state.password_confirmation}
            onChange={(event) => { this.handlePassword_confirmationChange(event) }}
            autocomplete="new-password" class="form-control" placeholder="確認用パスワードを入力してください" type="password" name="user[password_confirmation]" id="user_password_confirmation" />
        </div>
        {password_confirmationErrorText}

        <div class="action">
          <input
            disabled={this.state.email_error || this.state.password_error || this.state.participated_at_error || this.state.password_confirmation_error}
            type="submit" name="commit" value="登録する" class="btn btn-lg btn-warning btn-block" data-disable-with="登録する" />
        </div>
      </form>
    );
  }
}

export default SignUp
