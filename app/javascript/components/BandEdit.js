import React from "react";
import PropTypes from "prop-types";

let count = 0;

class BandEdit extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: this.props.band_name,
      name_error: false,
    };
    this.handleChangeName = this.handleChangeName.bind(this);
    this.handleLoad = this.handleLoad.bind(this);
  }

  componentDidMount() {
    window.addEventListener("load", () => {
      setTimeout(() => {
        this.props.members.map((member) => {
          document.getElementById(
            `band[relationships_attributes][${member["id"]}][part]`
          ).value = member["part"];
        });
      }, 0);
    });
  }

  handleLoad() {
    this.props.members.map((member) => {
      document.getElementById(
        `band[relationships_attributes][${member["id"]}][part]`
      ).value = member["part"];
    });
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

  render() {
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

        <label>バンド名を入力</label>
        <input
          onChange={(event) => {
            this.handleChangeName(event);
          }}
          type="text"
          value={this.state.name}
          name="band[name]"
        />
        {name_error_message}
        {this.props.members.map((member) => (
          <span key={member["id"]}>
            <div>
              <label>名前</label>
              <select
                name={`band[relationships_attributes][${member["id"]}][user_id]`}
              >
                <option value={member["user_id"]}>{member["name"]}</option>
              </select>
              <label>パート</label>
              <select
                name={`band[relationships_attributes][${member["id"]}][part]`}
                id={`band[relationships_attributes][${member["id"]}][part]`}
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
              <input
                type="hidden"
                name={`band[relationships_attributes][${member["id"]}][id]`}
                value={member["id"]}
              ></input>
            </div>
          </span>
        ))}

        <input
          disabled={this.state.name_error}
          type="submit"
          name="commit"
          value="確定する"
          data-confirm="本当によろしいですか？"
          className="btn btn-primary"
        ></input>
      </form>
    );
  }
}

export default BandEdit;
