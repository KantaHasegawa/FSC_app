import React from "react"
import PropTypes from "prop-types"

class ProfileImage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }



  render() {
    
    return (
      <form class="edit_user" id="edit_user" action="/users" enctype="multipart/form-data" accept-charset="UTF-8" method="post">
        <input type="hidden" name="_method" value="put"></input>
        <input type="hidden" name="authenticity_token" value={this.props.token} />

        <div class="field">
          <input type="file" accept="image/jpeg,image/png" name="user[image]" id="user_image" />
        </div>

        <div class="action">
          <input
            type="submit" name="commit" value="送信" class="btn btn-xs btn-warning" data-disable-with="送信" />
        </div>
      </form>
    );
  }
}

export default ProfileImage
