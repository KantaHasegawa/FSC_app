import React from "react";
import PropTypes from "prop-types";

let count = 0;

class BandEdit extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: this.props.band_name,
      name_error: false,
      image_form: false,
    };
    this.handleChangeName = this.handleChangeName.bind(this);
    this.handleChangeImageForm = this.handleChangeImageForm.bind(this);
  }

  handleChangeName(event) {
    const inputValue = event.target.value;
    this.setState({
      name: inputValue,
    });
    if (inputValue == "") {
      this.setState({
        name_error: true,
      });
    } else {
      this.setState({
        name_error: false,
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
    let image_button_message;
    let image_form;

    if (this.state.image_form) {
      image_button_message = "画像を変更しない";
      image_form = (
        <input
          type="file"
          accept="image/jpeg,image/png"
          name="band[image]"
        ></input>
      );
    } else {
      image_button_message = "画像を変更する";
      image_form = "";
    }

    let name_error_message;
    if (this.state.name_error) {
      name_error_message = (
        <div class="dynamic_error_message">※バンド名が入力されていません</div>
      );
    } else {
      name_error_message = "";
    }

    return (
      <form
        enctype="multipart/form-data"
        action={`/bands/${this.props.band_id}`}
        accept-charset="UTF-8"
        method="post"
      >
        <input
          type="hidden"
          name="authenticity_token"
          value={this.props.token}
        ></input>
        <input type="hidden" name="_method" value="patch"></input>
        <button type="button" onClick={this.handleChangeImageForm} class="btn btn-secondary">
          {image_button_message}
        </button>

        {image_form}

        {name_error_message}
        <div>
          <label class="label-margin">バンド名を入力</label>
          <input
            onChange={(event) => {
              this.handleChangeName(event);
            }}
            type="text"
            value={this.state.name}
            name="band[name]"
            class="form-control"
          />
        </div>

        {this.props.members.map((member) => (
          <span key={member["id"]}>
            <div class="row">
              <div class="col">
                <label class="label-margin">名前</label>
                <select
                  name={`band[relationships_attributes][${member["id"]}][user_id]`}
                  class="form-control"
                >
                  <option value={member["user_id"]}>{member["name"]}</option>
                </select>
              </div>
              <div class="col">
                <label class="label-margin">パート</label>
                <select
                  name={`band[relationships_attributes][${member["id"]}][part]`}
                  id={`band[relationships_attributes][${member["id"]}][part]`}
                  defaultValue={member["part"]}
                  class="form-control"
                >
                  <option value="Vocal">Vocal</option>
                  <option value="Guitar&Vocal">Guitar&Vocal</option>
                  <option value="Bass&Vocal">Bass&Vocal</option>
                  <option value="LeadGuitar">LeadGuitar</option>
                  <option value="RhythmGuitar">RhythmGuitar</option>
                  <option value="Bass">Bass</option>
                  <option value="Drums">Drums</option>
                  <option value="Keyboard">Keyboard</option>
                  <option value="その他">その他</option>
                </select>
              </div>
            </div>

            <input
              type="hidden"
              name={`band[relationships_attributes][${member["id"]}][id]`}
              value={member["id"]}
            ></input>
          </span>
        ))}

        <input
          disabled={this.state.name_error}
          type="submit"
          name="commit"
          value="確定する"
          data-confirm="本当によろしいですか？"
          className="btn btn-primary btn-block"
        ></input>
      </form>
    );
  }
}

export default BandEdit;
