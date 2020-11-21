import React from "react"
import PropTypes from "prop-types"

class EditUser extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: this.props.user.name,
      email: this.props.user.email,
      password: "",
      participated_at: this.props.user.participated_at,
      password_confirmation: "",
      name_error: false,
      email_error: false,
      password_error: false,
      participated_at_error: false,
      password_confirmation_error: false,
      image_form: false,
    };
    this.handleChangeImageForm = this.handleChangeImageForm.bind(this);
  }

  handleNameChange(event) {
    const inputValue = event.target.value;
    this.setState({
      name: inputValue,
    });
    if (inputValue === "") {
      this.setState({
        name_error: true,
      });
    } else {
      this.setState({
        name_error: false,
      });
    }
  }

  handleEmailChange(event) {
    const inputValue = event.target.value;
    this.setState({
      email: inputValue,
    });
    if (inputValue === "") {
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
      password: inputValue,
    });
    if (1 <= inputValue.length && inputValue.length < 6) {
      this.setState({
        password_error: true,
      });
    } else {
      this.setState({
        password_error: false,
      });
    }
  }

  handleParticipated_atChange(event) {
    const inputValue = event.target.value;
    this.setState({
      participated_at: inputValue,
    });
    if (inputValue < 1969 || 2050 < inputValue) {
      this.setState({
        participated_at_error: true,
      });
    } else {
      this.setState({
        participated_at_error: false,
      });
    }
  }

  handlePassword_confirmationChange(event) {
    const inputValue = event.target.value;
    this.setState({
      password_confirmation: inputValue,
    });
    if (inputValue != this.state.password) {
      this.setState({
        password_confirmation_error: true,
      });
    } else {
      this.setState({
        password_confirmation_error: false,
      });
    }
  }

  handleChangeImageForm() {
    let image_form = !this.state.image_form;
    this.setState({
      image_form: image_form,
    });
  }

  render() {

        let nameErrorText;
        if (this.state.name_error) {
          nameErrorText = (
            <div class="dynamic_error_message">※名前が入力されていません</div>
          );
        } else {
          nameErrorText = "";
        }

    let emailErrorText;
    if (this.state.email_error) {
      emailErrorText = (
        <div className="dynamic_error_message">
          ※メールアドレスが入力されていません
        </div>
      );
    } else {
      emailErrorText = "";
    }

    let passwordErrorText;
    if (this.state.password_error) {
      passwordErrorText = (
        <div className="dynamic_error_message">
          ※パスワードは英数字6文字以上で入力してください
        </div>
      );
    } else {
      passwordErrorText = "";
    }

    let participated_atErrorText;
    if (this.state.participated_at_error) {
      participated_atErrorText = (
        <div className="dynamic_error_message">
          ※入部年度が入力されていません
        </div>
      );
    } else {
      participated_atErrorText = "";
    }

    let password_confirmationErrorText;
    if (this.state.password_confirmation_error) {
      password_confirmationErrorText = (
        <div className="dynamic_error_message">※パスワードが一致しません</div>
      );
    } else {
      password_confirmationErrorText = "";
    }

    let man;
    if (this.props.user.gender == 0) {
      man = true;
    } else {
      man = false;
    }

    let woman;
    if (this.props.user.gender == 1) {
      woman = true;
    } else {
      woman = false;
    }

    let image_button_message;
    let image_form;

    if (this.state.image_form) {
      image_button_message = "画像を変更しない";
      image_form = (
        <input
          type="file"
          accept="image/jpeg,image/png"
          name="user[image]"
        ></input>
      );
    } else {
      image_button_message = "画像を変更する";
      image_form = "";
    }

    return (
      <form
        className="edit_user"
        action="/users"
        acceptCharset="UTF-8"
        method="post"
        enctype="multipart/form-data"
      >
        <input type="hidden" name="_method" value="put"></input>
        <input
          type="hidden"
          name="authenticity_token"
          value={this.props.token}
        />

        <button
          type="button"
          class="btn btn-secondary"
          onClick={this.handleChangeImageForm}
        >
          {image_button_message}
        </button>

        {image_form}

        <div className="topandbottom5px">
          <div className="radio">
            <label>
              <input
                type="radio"
                value="0"
                name="user[gender]"
                defaultChecked={man}
              />
              男
            </label>
          </div>
          <div className="radio">
            <label>
              <input
                type="radio"
                value="1"
                name="user[gender]"
                defaultChecked={woman}
              />
              女
            </label>
          </div>
        </div>

        <div class="field">
          <input
            value={this.state.name}
            onChange={(event) => {
              this.handleNameChange(event);
            }}
            placeholder="名前を入力してください"
            class="form-control"
            autocomplete="name"
            type="name"
            name="user[name]"
            id="user_name"
          />
        </div>
        {nameErrorText}

        <div class="field">
          <select
            class="form-control"
            name="user[main_part]"
            id="user_main_part"
          >
            <option value="Vocal">Vocal</option>
            <option value="Guitar">Guitar</option>
            <option value="Bass">Bass</option>
            <option value="Drums">Drums</option>
            <option value="Keyboard">Keyboard</option>
          </select>
        </div>

        <div className="field">
          <select className="form-control" name="user[roll]">
            <option value="平部員">平部員</option>
            <option value="平部長">平部長</option>
            <option value="幹事">幹事</option>
            <option value="会計">会計</option>
            <option value="渉外">渉外</option>
            <option value="機材">機材</option>
            <option value="部長">部長</option>
            <option value="副部長">副部長</option>
            <option value="次期部長">次期部長</option>
            <option value="次期副部長">次期副部長</option>
          </select>
        </div>

        <div className="field">
          <input
            value={this.state.participated_at}
            onChange={(event) => {
              this.handleParticipated_atChange(event);
            }}
            className="form-control"
            placeholder="入部した年を入力してください"
            type="number"
            name="user[participated_at]"
          />
        </div>
        {participated_atErrorText}

        <div className="field">
          <input
            value={this.state.email}
            onChange={(event) => {
              this.handleEmailChange(event);
            }}
            placeholder="メールアドレスを入力してください"
            className="form-control"
            type="email"
            name="user[email]"
          />
        </div>
        {emailErrorText}
        <div className="field">
          <input
            value={this.state.password}
            onChange={(event) => {
              this.handlePasswordChange(event);
            }}
            placeholder="パスワード(変更しない場合は空)"
            className="form-control"
            type="password"
            name="user[password]"
          />
        </div>
        {passwordErrorText}

        <div className="field">
          <input
            value={this.state.password_confirmation}
            onChange={(event) => {
              this.handlePassword_confirmationChange(event);
            }}
            className="form-control"
            placeholder="確認用パスワード(変更しない場合は空)"
            type="password"
            name="user[password_confirmation]"
          />
        </div>
        {password_confirmationErrorText}

        <div className="action">
          <input
            disabled={
              this.state.name_error ||
              this.state.email_error ||
              this.state.password_error ||
              this.state.participated_at_error ||
              this.state.password_confirmation_error
            }
            type="submit"
            name="commit"
            value="変更する"
            className="btn btn-primary btn-block"
          />
        </div>
      </form>
    );
  }
}

export default EditUser
